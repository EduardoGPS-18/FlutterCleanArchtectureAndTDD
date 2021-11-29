import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import 'models.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) => LocalSurveyResultModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: entity.answers.map((entity) => LocalSurveyAnswerModel.fromEntity(entity)).toList(),
      );

  SurveyResultEntity toEntity() {
    return SurveyResultEntity(
      answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      question: question,
      surveyId: surveyId,
    );
  }

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw Exception();
    }
    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<LocalSurveyAnswerModel>((answerJson) => LocalSurveyAnswerModel.fromJson(answerJson)).toList(),
    );
  }
  Map toJson() => {
        'surveyId': surveyId,
        'question': question,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}
