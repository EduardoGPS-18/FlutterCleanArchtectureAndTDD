import 'package:faker/faker.dart';

class ApiFactory {
  static Map<String, dynamic> makeAccountJson() {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }

  static List<Map<String, dynamic>> makeSurveys() => [
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

  static List<Map<String, dynamic>> makeSurveysWithIncompleteData() => [
        {
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'false',
        }
      ];

  static List<Map<String, dynamic>> makeInvalidSurveys() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalidDate',
          'didAnswer': "true",
        }
      ];

  static Map<String, dynamic> makeSurveyResultJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(50),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(50),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  static Map<String, dynamic> makeInvalidJson() => {'invalid_key': 'invalid_data'};
}
