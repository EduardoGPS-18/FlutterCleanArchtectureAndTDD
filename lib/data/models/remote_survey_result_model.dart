import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import 'models.dart';
import '../http/http.dart';

class RemoteSurveyResultModel extends SurveyResultEntity {
  RemoteSurveyResultModel({
    @required String surveyId,
    @required String question,
    @required List<SurveyAnswerEntity> answers,
  }) : super(
          surveyId: surveyId,
          answers: answers,
          question: question,
        );

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'answers', 'question'])) {
      throw HttpError.invalidData;
    }
    final convertedAnswers = ((json['answers'] as List<Map<String, dynamic>>) ?? [])
        .map<SurveyAnswerEntity>((ans) => RemoteSurveyAnswerResultModel.fromJson(ans).toEntity())
        .toList();
    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      answers: convertedAnswers,
      question: json['question'],
    );
  }

  SurveyResultEntity toEntity() {
    return SurveyResultEntity(
      answers: answers,
      question: question,
      surveyId: surveyId,
    );
  }
}
