import 'package:faker/faker.dart';

class CacheFactory {
  static Map<String, dynamic> makeSurveyResultData() => {
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

  static List<Map<String, dynamic>> makeSurveysData() => [
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

  static List<Map<String, dynamic>> makeSurveysWithIncompleteData() => [
        {
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'false',
        }
      ];

  static List<Map<String, dynamic>> makeInvalidSurveysData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalidDate',
          'didAnswer': "true",
        }
      ];

  static Map<String, dynamic> makeInvalidSurveyResultData() => {
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
      };

  static Map<String, dynamic> makeIncompleteSurveyResultData() => {
        'surveyId': faker.guid.guid(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid_boolean',
            'percent': 'invalid_int',
          }
        ],
      };
}
