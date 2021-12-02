import '../../domain/entities/entities.dart';

import 'models.dart';
import '../http/http.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerResultModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'answers', 'question'])) {
      throw HttpError.invalidData;
    }
    final convertedAnswers =
        (json['answers'] ?? []).map<RemoteSurveyAnswerResultModel>((ans) => RemoteSurveyAnswerResultModel.fromJson(ans)).toList();
    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      answers: convertedAnswers,
      question: json['question'],
    );
  }

  SurveyResultEntity toEntity() {
    return SurveyResultEntity(
      answers: answers.map((answer) => answer.toEntity()).toList(),
      question: question,
      surveyId: surveyId,
    );
  }
}
