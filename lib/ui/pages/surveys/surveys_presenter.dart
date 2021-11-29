import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<String> get navigateToStream;
  Stream<List<SurveyViewModel>> get surveysDataStream;

  Future<void> loadData();

  void goToSurveyResult(String surveyId);
}
