abstract class LoginPresenter {
  Stream<String> get mainErrorController;
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidController;
  Stream<bool> get isLoadinController;

  Future<void> auth();
  void dispose();

  void validateEmail(String email);
  void validatePassword(String pass);
}
