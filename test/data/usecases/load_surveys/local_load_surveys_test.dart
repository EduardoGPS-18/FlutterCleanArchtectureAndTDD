import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/survey_entity.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';

import 'package:app_curso_manguinho/data/models/models.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await fetchCacheStorage.fetch(key: 'surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<dynamic> fetch({@required String key});
}

void main() {
  FetchCacheStorage fetchCacheStorage;
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

  PostExpectation mockFetchCall() => when(fetchCacheStorage.fetch(key: anyNamed('key')));
  void mockFetch(List<Map> list) => mockFetchCall().thenAnswer((_) async => list);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData);
  });

  test('Should call fetch cache storage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch(key: 'surveys')).called(1);
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
}
