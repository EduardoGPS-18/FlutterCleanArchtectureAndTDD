import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/usecases/load_survey_result/local_load_survey_result.dart';
import 'package:app_curso_manguinho/data/cache/cache.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('loadBySurvey', () {
    CacheStorage cacheStorage;
    LocalLoadSurveyResult sut;
    String surveyId;

    Map data;
    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'true',
              'percent': '40',
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'false',
              'percent': '68',
            },
          ],
        };

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));
    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();
      mockFetch(mockValidData());
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return survey result on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);
      final expectedSurveyResult = SurveyResultEntity(
        question: data['question'],
        surveyId: data['surveyId'],
        answers: [
          SurveyAnswerEntity(
            answer: data['answers'][0]['answer'],
            isCurrentAnswer: true,
            percent: 40,
            image: data['answers'][0]['image'],
          ),
          SurveyAnswerEntity(
            answer: data['answers'][1]['answer'],
            isCurrentAnswer: false,
            percent: 68,
          ),
        ],
      );
      expect(surveyResult, expectedSurveyResult);
    });

    test('Should throws unexpected error if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is invalid', () async {
      mockFetch(
        {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'invalid_boolean',
              'percent': 'invalid_int',
            }
          ],
        },
      );

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is incomplete', () async {
      mockFetch(
        {
          'surveyId': faker.guid.guid(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'invalid_boolean',
              'percent': 'invalid_int',
            }
          ],
        },
      );

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    CacheStorage cacheStorage;
    LocalLoadSurveyResult sut;
    String surveyId;

    Map data;
    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'true',
              'percent': '40',
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'false',
              'percent': '68',
            },
          ],
        };

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));
    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call fetch cache storage with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(
        {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'invalid_boolean',
              'percent': 'invalid_int',
            }
          ],
        },
      );
      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache when fetch throws', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });
}
