import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoading;
  Stream<bool> get isSessionExpiredStream;
  Future<void> loadData();
  Stream<SurveyResultViewModel> get surveyResultStream;
}
