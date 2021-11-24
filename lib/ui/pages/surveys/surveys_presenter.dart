import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoading;
  Stream<List<SurveyViewModel>> get surveysDataStream;

  Future<void> loadData();
}
