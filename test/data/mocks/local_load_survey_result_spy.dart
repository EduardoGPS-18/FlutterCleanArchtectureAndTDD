import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    mockSave();
    mockValidate();
  }

  When mockLoadCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity localResult) => mockLoadCall().thenAnswer((_) async => localResult);
  void mockLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
}
