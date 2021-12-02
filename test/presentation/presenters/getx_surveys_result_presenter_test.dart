import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late String answer;
  late String surveyId;
  late GetxSurveyResultPresenter sut;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late LoadSurveyResultSpy loadSurveyResult;
  late SaveSurveyResultSpy saveSurveyResult;

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) => SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
            image: entity.answers[0].image,
            answer: entity.answers[0].answer,
            isCurrentAnswer: entity.answers[0].isCurrentAnswer,
            percent: '${entity.answers[0].percent}%',
          ),
          SurveyAnswerViewModel(
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          ),
        ],
      );

  setUp(() {
    answer = faker.randomGenerator.string(50);
    surveyId = faker.randomGenerator.string(50);
    saveSurveyResult = SaveSurveyResultSpy();
    loadSurveyResult = LoadSurveyResultSpy();

    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );
    loadResult = EntityFactory.makeSurveyResult();
    loadSurveyResult.mockLoad(loadResult);
    saveResult = EntityFactory.makeSurveyResult();
    saveSurveyResult.mockSave(saveResult);
  });

  group('load data', () {
    test('Should call load surveys usecase when sut call load data', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(expectAsync1(
        (result) => expect(
          result,
          SurveyResultViewModel(
            surveyId: loadResult.surveyId,
            question: loadResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: loadResult.answers[0].image,
                answer: loadResult.answers[0].answer,
                isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                percent: '${loadResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: loadResult.answers[1].answer,
                isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                percent: '${loadResult.answers[1].percent}%',
              ),
            ],
          ),
        ),
      ));

      await sut.loadData();
    });

    test('Should thorws error if load survey result throws', () async {
      loadSurveyResult.mockLoadError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: expectAsync1(
          (error) => expect(
            error,
            UIError.unexpected.description,
          ),
        ),
      );

      await sut.loadData();
    });

    test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
      loadSurveyResult.mockLoadError(DomainError.accessDenied);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder([true, false]),
      );
      expectLater(
        sut.isSessionExpiredStream,
        emits(true),
      );

      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call save surveys result on save', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.surveyResultStream,
        emitsInOrder([
          mapToViewModel(loadResult),
          mapToViewModel(saveResult),
        ]),
      );

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should thorws error if load survey result throws', () async {
      saveSurveyResult.mockSaveError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: expectAsync1(
          (error) => expect(
            error,
            UIError.unexpected.description,
          ),
        ),
      );

      await sut.save(answer: answer);
    });

    test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
      saveSurveyResult.mockSaveError(DomainError.accessDenied);
      expectLater(
        sut.isLoadingStream,
        emitsInOrder([true, false]),
      );
      expectLater(
        sut.isSessionExpiredStream,
        emits(true),
      );

      await sut.save(answer: answer);
    });
  });
}
