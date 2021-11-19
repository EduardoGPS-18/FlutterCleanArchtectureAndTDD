abstract class LoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidController;

  void auth();

  void validateEmail(String email);
  void validatePassword(String pass);
}
