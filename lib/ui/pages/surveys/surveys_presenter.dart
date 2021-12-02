import 'package:flutter/foundation.dart';

import 'survey_viewmodel.dart';

abstract class SurveysPresenter extends Listenable {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<String?> get navigateToStream;
  Stream<List<SurveyViewModel>> get surveysDataStream;

  Future<void> loadData();

  void goToSurveyResult(String surveyId);
}
