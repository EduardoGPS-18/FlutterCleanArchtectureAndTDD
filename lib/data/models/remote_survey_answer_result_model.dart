import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyAnswerResultModel extends SurveyAnswerEntity {
  RemoteSurveyAnswerResultModel({
    @required int percent,
    @required bool isCurrentAccountAnswer,
    @required String answer,
    @required String image,
  }) : super(
          percent: percent,
          isCurrentAnswer: isCurrentAccountAnswer,
          answer: answer,
          image: image,
        );

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
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );
}
