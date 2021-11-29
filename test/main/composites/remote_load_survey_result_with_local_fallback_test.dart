import 'package:app_curso_manguinho/domain/usecases/load_surveys_result.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/data/usecases/load_survey_result/local_load_survey_result.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    final res = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: res);
    return res;
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  String surveyId;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultSpy remote;
  SurveyResultEntity surveyResult;
  RemoteLoadSurveyResultWithLocalFallback sut;

  void mockSurveyResult() {
    surveyResult = SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100),
        ),
      ],
    );

    when(remote.loadBySurvey(
      surveyId: anyNamed('surveyId'),
    )).thenAnswer((_) async => surveyResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockSurveyResult();
  });

  test('Should call remote load by survey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: surveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
  });
}
