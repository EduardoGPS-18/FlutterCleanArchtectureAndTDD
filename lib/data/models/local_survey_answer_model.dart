import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  SurveyAnswerEntity toEntity() {
    return SurveyAnswerEntity(
      image: image,
      answer: answer,
      isCurrentAnswer: isCurrentAnswer,
      percent: percent,
    );
  }

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw Exception();
    }
    return LocalSurveyAnswerModel(
      isCurrentAnswer: json['isCurrentAnswer'] == 'true' ? true : false,
      percent: int.parse(json['percent']),
      answer: json['answer'],
      image: json['image'],
    );
  }
}
