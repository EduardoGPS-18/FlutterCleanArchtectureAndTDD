import '../../../ui/helpers/errors/errors.dart';

abstract class LoginPresenter {
  Stream<UIError> get mainErrorStream;
  Stream<UIError> get emailErrorStream;
  Stream<String> get navigateToStream;
  Stream<UIError> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  Future<void> auth();
  void dispose();

  void validateEmail(String email);
  void validatePassword(String pass);
}
