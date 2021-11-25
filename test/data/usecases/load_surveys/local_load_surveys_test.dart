import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    CacheStorage cacheStorage;
    LocalLoadSurveys sut;

    List<Map> mockValidData = [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2018-02-25T00:00:00Z',
        'didAnswer': 'false',
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2020-04-27T00:00:00Z',
        'didAnswer': "true",
      },
    ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));
    void mockFetch(List<Map> list) => mockFetchCall().thenAnswer((_) async => list);
    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData);
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final data = mockValidData;

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
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalidData',
          'didAnswer': 'false',
        },
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is incomplete', () async {
      mockFetch([
        {
          'date': '2020-04-27T00:00:00Z',
          'didAnswer': 'false',
        },
      ]);

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

    List<Map> mockValidData = [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2018-02-25T00:00:00Z',
        'didAnswer': 'false',
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2020-04-27T00:00:00Z',
        'didAnswer': "true",
      },
    ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));
    void mockFetch(List<Map> list) => mockFetchCall().thenAnswer((_) async => list);

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData);
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });
  });
}
