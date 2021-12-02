import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity remoteResult) => mockLoadCall().thenAnswer((_) async => remoteResult);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}
