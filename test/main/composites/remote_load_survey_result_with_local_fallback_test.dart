import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import 'package:app_curso_manguinho/main/composites/composites.dart';

import '../../mocks/mocks.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  String surveyId;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultSpy remote;
  SurveyResultEntity remoteResult, localResult;
  RemoteLoadSurveyResultWithLocalFallback sut;

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));
  void mockRemoteLoad() {
    remoteResult = FakeSurveyResultFactory.makeEntity();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));
  void mockLocalLoad() {
    localResult = FakeSurveyResultFactory.makeEntity();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load by survey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote load by survey throws access denied error', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local load by survey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should rethrow if local throw', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
