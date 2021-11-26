abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> isLoading;
}
