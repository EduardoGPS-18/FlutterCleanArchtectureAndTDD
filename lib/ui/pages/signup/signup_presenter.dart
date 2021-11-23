import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UIError> nameErrorController;
  Stream<UIError> emailErrorController;
  Stream<UIError> passwordErrorController;
  Stream<UIError> passwordConfirmationErrorController;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validateConfirmPassword(String confirmPassword);
}
