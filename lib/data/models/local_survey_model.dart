import 'package:meta/meta.dart';

import '../http/http.dart';

import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  SurveyEntity toEntity() => SurveyEntity(
        dateTime: date,
        didAnswer: didAnswer,
        id: id,
        question: question,
      );

  factory LocalSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw HttpError.invalidData;
    }
    return LocalSurveyModel(
      date: DateTime.parse(json['date']),
      didAnswer: (json['didAnswer']) == 'true' ? true : false,
      id: json['id'],
      question: json['question'],
    );
  }
}
