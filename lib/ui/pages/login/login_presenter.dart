import 'package:flutter/foundation.dart';

import '../../../ui/helpers/errors/errors.dart';

abstract class LoginPresenter extends Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  Future<void> auth();

  void goToSignUp();

  void validateEmail(String email);
  void validatePassword(String pass);
}
