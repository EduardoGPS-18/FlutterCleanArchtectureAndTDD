import '../http/http.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final DateTime date;
  final bool didAnswer;
  final String question;

  LocalSurveyModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  SurveyEntity toEntity() => SurveyEntity(
        dateTime: date,
        didAnswer: didAnswer,
        id: id,
        question: question,
      );

  Map<String, String> toJson() => {
        'id': id,
        'question': question,
        'didAnswer': didAnswer.toString(),
        'date': date.toIso8601String(),
      };

  factory LocalSurveyModel.fromEntity(SurveyEntity entity) => LocalSurveyModel(
        id: entity.id,
        question: entity.question,
        date: entity.dateTime,
        didAnswer: entity.didAnswer,
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
