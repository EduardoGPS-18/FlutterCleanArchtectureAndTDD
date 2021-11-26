import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';

import '../pages.dart';
import 'survey_answer_view_model.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory SurveyResultViewModel.fromEntity(SurveyResultEntity entity) {
    return SurveyResultViewModel(
      surveyId: entity.surveyId,
      question: entity.question,
      answers: entity.answers.map((entity) => SurveyAnswerViewModel.fromEntity(entity)).toList(),
    );
  }

  @override
  List<Object> get props => [surveyId, question, answers];
}
