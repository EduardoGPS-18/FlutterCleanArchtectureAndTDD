import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadSurveysCall() => when(() => this.load());
  void mockLoadSurveys(List<SurveyEntity> surveys) => mockLoadSurveysCall().thenAnswer((_) async => surveys);
  void mockLoadSurveysError(DomainError error) => mockLoadSurveysCall().thenThrow(error);
}
