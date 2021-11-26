import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResult loadSurveyResult;
  String surveyId;

  SurveyResultEntity surveyResult = SurveyResultEntity(
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

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(
        surveyId: anyNamed('surveyId'),
      ));
  void mockLoadSurveyResult(SurveyResultEntity mockedSurveyResult) {
    surveyResult = mockedSurveyResult;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError() => mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.randomGenerator.string(50);
    loadSurveyResult = LoadSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(surveyResult);
  });

  test('Should call load surveys usecase when sut call load data', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoading, emitsInOrder([true, false]));

    sut.surveyResultStream.listen(expectAsync1(
      (result) => expect(
        result,
        SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: [
            SurveyAnswerViewModel(
              image: surveyResult.answers[0].image,
              answer: surveyResult.answers[0].answer,
              isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
              percent: '${surveyResult.answers[0].percent}%',
            ),
            SurveyAnswerViewModel(
              answer: surveyResult.answers[1].answer,
              isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
              percent: '${surveyResult.answers[1].percent}%',
            ),
          ],
        ),
      ),
    ));

    await sut.loadData();
  });

  test('Should thorws error if load survey result throws', () async {
    mockLoadSurveyResultError();

    expectLater(sut.isLoading, emitsInOrder([true, false]));
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
}
