import '../../domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  final int percent;
  final String? image;
  final String answer;
  final bool isCurrentAnswer;

  LocalSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) => LocalSurveyAnswerModel(
        answer: entity.answer,
        image: entity.image,
        isCurrentAnswer: entity.isCurrentAnswer,
        percent: entity.percent,
      );

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

  Map toJson() => {
        'image': image,
        'answer': answer,
        'percent': '$percent',
        'isCurrentAnswer': isCurrentAnswer.toString(),
      };
}
