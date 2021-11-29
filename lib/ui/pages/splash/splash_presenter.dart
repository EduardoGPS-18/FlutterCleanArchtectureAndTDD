abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> checkCurrentAccount({int durationInSeconds});
}
