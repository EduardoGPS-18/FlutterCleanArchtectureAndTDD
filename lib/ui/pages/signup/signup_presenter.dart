import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UIError> nameErrorStream;
  Stream<UIError> emailErrorStream;
  Stream<UIError> passwordErrorStream;
  Stream<UIError> passwordConfirmationErrorStream;
  Stream<bool> isFormValidStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validateConfirmPassword(String confirmPassword);
  void signUp();
}
