abstract class SurveysPresenter {
  Stream<bool> get isLoading;

  Future<void> loadData();
}
