import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:faker/faker.dart';

class FakeSurveysFactory {
  static List<Map<String, dynamic>> makeCacheJson() => [
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

  static List<Map<String, dynamic>> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalidDate',
          'didAnswer': "true",
        }
      ];

  static List<Map<String, dynamic>> makeIncompleteCacheJson() => [
        {
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'false',
        }
      ];

  static List<Map<String, dynamic>> makeInvalidApiJson() => [
        {
          'invalid_key': 'invalid_data',
        }
      ];

  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2018, 02, 25),
          didAnswer: false,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2020, 04, 27),
          didAnswer: true,
        ),
      ];
  static List<SurveyViewModel> makeViewModel() => [
        SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  static List<Map<String, dynamic>> makeApiJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];
}
