import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entities.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  @override
  List<Object> get props => [surveyId, question, answers];
}
