import 'package:meta/meta.dart';

import 'entities.dart';

class SurveyResultEntity {
  final String id;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    @required this.id,
    @required this.question,
    @required this.didAnswer,
    @required this.answers,
  });
}
