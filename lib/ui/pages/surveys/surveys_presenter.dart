import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoading;
  Stream<bool> get isSessionExpiredStream;
  Stream<String> get navigateTo;
  Stream<List<SurveyViewModel>> get surveysDataStream;

  Future<void> loadData();

  void goToSurveyResult(String surveyId);
}
