import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {
  LocalLoadSurveysSpy() {
    mockSave();
    mockValidate();
  }

  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SurveyEntity> surveys) => mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate());
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
}
