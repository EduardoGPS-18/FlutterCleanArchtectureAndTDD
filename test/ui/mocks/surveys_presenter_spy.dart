import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final navigateToController = StreamController<String>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final surveysDataController = StreamController<List<SurveyViewModel>>();

  SurveysPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveysDataStream).thenAnswer((_) => surveysDataController.stream);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => this.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSessionExpired([bool expired = true]) => isSessionExpiredController.add(expired);
  void emitSurveys(List<SurveyViewModel> surveys) => surveysDataController.add(surveys);
  void emitSurveyError(String error) => surveysDataController.addError(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    surveysDataController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
    navigateToController.close();
  }
}
