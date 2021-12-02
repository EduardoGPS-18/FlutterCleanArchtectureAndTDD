import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock with EmitLoading, EmitSessionExpired implements SurveyResultPresenter {
  final surveyResultController = StreamController<SurveyResultViewModel>();

  SurveyResultPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.save(answer: any(named: 'answer'))).thenAnswer((_) async => _);

    when(() => this.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    when(() => this.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  void emitSurveyResult(SurveyResultViewModel survey) => surveyResultController.add(survey);
  void emitSurveyResultError(String error) => surveyResultController.addError(error);

  void dispose() {
    surveyResultController.close();
    isLoadingController.close();
    isSessionExpiredController.close();
  }
}
