abstract class SplashPresenter {
  Stream<String> get navigateStream;
  Future<void> checkCurrentAccount({int durationInSeconds});
}
