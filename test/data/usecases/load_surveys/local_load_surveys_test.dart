import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;
    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => list);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
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
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is null', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache throws', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;
    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) => mockFetchCall().thenAnswer((_) async => list);

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());
      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache when fetch throws', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;
    List<SurveyEntity> surveys;

    PostExpectation mockSaveCall() => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));
    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = FakeSurveysFactory.makeEntities();
    });

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

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
