import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResult loadSurveyResult;
  SaveSurveyResult saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

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
            image: null,
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          ),
        ],
      );

  SurveyResultEntity mockValidData() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
            image: faker.internet.httpUrl(),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
      );

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(
        answer: anyNamed('answer'),
      ));
  void mockSaveSurveyResult(SurveyResultEntity mockedSurveyResult) {
    saveResult = mockedSurveyResult;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(
        surveyId: anyNamed('surveyId'),
      ));
  void mockLoadSurveyResult(SurveyResultEntity mockedSurveyResult) {
    loadResult = mockedSurveyResult;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

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
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('load data', () {
    test('Should call load surveys usecase when sut call load data', () async {
      await sut.loadData();

      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
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
      mockLoadSurveyResultError(DomainError.unexpected);

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
      mockLoadSurveyResultError(DomainError.accessDenied);

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

      verify(saveSurveyResult.save(answer: answer)).called(1);
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
      mockSaveSurveyResultError(DomainError.unexpected);

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
      mockSaveSurveyResultError(DomainError.accessDenied);
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
