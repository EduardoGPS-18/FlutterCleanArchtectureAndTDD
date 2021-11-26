import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> get isLoading;
  Stream<SurveyResultViewModel> get surveyResultStream;
}
