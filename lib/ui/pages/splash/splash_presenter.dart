abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> checkCurrentAccount({required int durationInSeconds});
}
