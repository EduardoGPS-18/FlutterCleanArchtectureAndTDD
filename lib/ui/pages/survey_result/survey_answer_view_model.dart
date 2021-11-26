import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';

class SurveyAnswerViewModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  SurveyAnswerViewModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  factory SurveyAnswerViewModel.fromEntity(SurveyAnswerEntity entity) => SurveyAnswerViewModel(
        answer: entity.answer,
        isCurrentAnswer: entity.isCurrentAnswer,
        percent: '${entity.percent}%',
        image: entity.image,
      );

  @override
  List<Object> get props => [image, answer, isCurrentAnswer, percent];
}
