import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  SurveyEntity toEntity() => SurveyEntity(
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
        id: id,
        question: question,
      );

  factory RemoteSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyModel(
      date: json['date'],
      didAnswer: json['didAnswer'],
      id: json['id'],
      question: json['question'],
    );
  }
}
