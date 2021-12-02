import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LocalLoadSurveysSpy local;
  late RemoteLoadSurveysSpy remote;
  late List<SurveyEntity> localSurveys;
  late List<SurveyEntity> remoteSurveys;
  late RemoteLoadSurveysWithLocalFallback sut;

  setUp(() {
    local = LocalLoadSurveysSpy();
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );

    remoteSurveys = EntityFactory.makeSurveys();
    remote.mockLoad(remoteSurveys);

    localSurveys = EntityFactory.makeSurveys();
    local.mockLoad(localSurveys);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throw access denied error', () async {
    remote.mockLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    remote.mockLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw unexpected error if remote and local throws', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
