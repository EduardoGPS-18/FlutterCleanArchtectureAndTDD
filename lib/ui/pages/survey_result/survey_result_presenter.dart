import 'survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> isLoading;
  Stream<SurveyResultViewModel> surveysData;
}
