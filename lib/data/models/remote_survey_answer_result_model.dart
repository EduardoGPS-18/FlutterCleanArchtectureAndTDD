import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyAnswerResultModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerResultModel({
    @required this.percent,
    @required this.isCurrentAccountAnswer,
    @required this.answer,
    @required this.image,
  });

  factory RemoteSurveyAnswerResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['percent', 'answer', 'isCurrentAccountAnswer'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyAnswerResultModel(
      image: json['image'],
      answer: json['answer'],
      percent: json['percent'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: answer,
        image: image,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
      );
}
