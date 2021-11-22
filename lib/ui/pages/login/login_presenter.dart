abstract class LoginPresenter {
  Stream<String> get mainErrorStream;
  Stream<String> get emailErrorStream;
  Stream<String> get navigateToStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  Future<void> auth();
  void dispose();

  void validateEmail(String email);
  void validatePassword(String pass);
}
