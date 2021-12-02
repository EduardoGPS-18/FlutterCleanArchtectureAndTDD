import 'package:faker/faker.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(token: faker.guid.guid());

  static SurveyResultEntity makeSurveyResult() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: true,
            percent: 40,
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: false,
            percent: 68,
          ),
        ],
      );

  static List<SurveyEntity> makeSurveys() => [
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
}
