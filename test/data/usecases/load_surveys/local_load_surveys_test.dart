import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late List<Map> data;
  late List<SurveyEntity> surveys;

  late LocalLoadSurveys sut;
  late CacheStorageSpy cacheStorage;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);

    surveys = EntityFactory.makeSurveys();
    data = CacheFactory.makeSurveysData();

    cacheStorage.mockFetch(data);
  });

  group('load', () {
    test('Should call fetch cache storage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2018, 02, 25),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.utc(2020, 04, 27),
          didAnswer: true,
        ),
      ]);
    });

    test('Should throws unexpected error if cache is empty', () async {
      cacheStorage.mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is invalid', () async {
      cacheStorage.mockFetch(ApiFactory.makeSurveysWithIncompleteData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is incomplete', () async {
      cacheStorage.mockFetch(ApiFactory.makeSurveysWithIncompleteData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call fetch cache storage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveysData());
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache when fetch throws', () async {
      cacheStorage.mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    test('Should call save cache storage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': DateTime.utc(2018, 02, 25).toIso8601String(),
          'didAnswer': 'false',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': DateTime.utc(2020, 04, 27).toIso8601String(),
          'didAnswer': 'true',
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
