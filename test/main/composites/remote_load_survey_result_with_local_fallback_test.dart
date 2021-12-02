import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late String surveyId;
  late LocalLoadSurveyResultSpy local;
  late RemoteLoadSurveyResultSpy remote;
  late SurveyResultEntity remoteResult, localResult;
  late RemoteLoadSurveyResultWithLocalFallback sut;

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );

    remoteResult = EntityFactory.makeSurveyResult();
    remote.mockLoad(remoteResult);
    localResult = EntityFactory.makeSurveyResult();
    local.mockLoad(localResult);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote load by survey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote load by survey throws access denied error', () async {
    remote.mockLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local load by survey on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    remote.mockLoadError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should rethrow if local throw', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
