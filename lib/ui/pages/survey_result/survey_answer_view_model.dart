import 'package:equatable/equatable.dart';

class SurveyAnswerViewModel extends Equatable {
  final String? image;
  final String answer;
  final String percent;
  final bool isCurrentAnswer;

  SurveyAnswerViewModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  @override
  List get props => [image, answer, isCurrentAnswer, percent];
}
