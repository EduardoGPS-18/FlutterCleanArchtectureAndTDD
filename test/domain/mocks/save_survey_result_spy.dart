import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveCall() => when(() => this.save(answer: any(named: 'answer')));
  void mockSave(SurveyResultEntity surveyResult) => mockSaveCall().thenAnswer((_) async => surveyResult);
  void mockSaveError(DomainError error) => mockSaveCall().thenThrow(error);
}
