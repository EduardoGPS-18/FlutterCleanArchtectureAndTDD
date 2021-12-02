import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late Map data;
  late String surveyId;
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late SurveyResultEntity surveyResult;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

    surveyResult = EntityFactory.makeSurveyResult();
    surveyId = surveyResult.surveyId;

    data = CacheFactory.makeSurveyResultData();
    cacheStorage.mockFetch(data);
  });

  group('loadBySurvey', () {
    test('Should call fetch cache storage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
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
      cacheStorage.mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is invalid', () async {
      cacheStorage.mockFetch(ApiFactory.makeInvalidJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResultData());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throws unexpected error if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call fetch cache storage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResultData());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache when fetch throws', () async {
      cacheStorage.mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    test('Should call save cache storage with correct values', () async {
      final toSaveData = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'isCurrentAnswer': 'true',
            'percent': '40',
          },
          {
            'image': surveyResult.answers[1].image,
            'answer': surveyResult.answers[1].answer,
            'isCurrentAnswer': 'false',
            'percent': '68',
          },
        ],
      };

      await sut.save(surveyResult);

      verify(() => cacheStorage.save(key: 'survey_result/$surveyId', value: toSaveData)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
