import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
  final String id;
  final bool didAnswer;
  final String question;
  final DateTime dateTime;

  SurveyEntity({
    required this.id,
    required this.question,
    required this.dateTime,
    required this.didAnswer,
  });

  @override
  List<Object> get props => [id, question, dateTime, didAnswer];
}
