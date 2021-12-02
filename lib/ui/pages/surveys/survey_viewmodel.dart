import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';

class SurveyViewModel extends Equatable {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  SurveyViewModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  factory SurveyViewModel.fromEntity(SurveyEntity entity) {
    return SurveyViewModel(
      id: entity.id,
      question: entity.question,
      date: DateFormat("dd MMM yyyy").format(entity.dateTime),
      didAnswer: entity.didAnswer,
    );
  }

  @override
  List<Object> get props => [id, question, date, didAnswer];
}
