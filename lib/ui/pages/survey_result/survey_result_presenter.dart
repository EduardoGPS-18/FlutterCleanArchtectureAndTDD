import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;

  Stream<SurveyResultViewModel> get surveyResultStream;

  Future<void> loadData();
}
