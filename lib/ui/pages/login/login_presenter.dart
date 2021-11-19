abstract class LoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidController;

  void validateEmail(String email);
  void validatePassword(String pass);
}
