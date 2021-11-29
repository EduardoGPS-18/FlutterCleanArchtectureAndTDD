import 'package:app_curso_manguinho/presentation/mixins/form_manager.dart';
import 'package:app_curso_manguinho/presentation/mixins/main_error_manager.dart';
import 'package:app_curso_manguinho/presentation/mixins/navigate_manager.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/domain_error.dart';

import '../../presentation/protocols/protocols.dart';
import '../mixins/mixins.dart';

import '../../ui/pages/login/login.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, FormManager, NavigateManager, MainErrorManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authenticationUsecase;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authenticationUsecase,
    @required this.saveCurrentAccount,
  });

  Future<void> auth() async {
    try {
      isLoading = true;
      final account = await authenticationUsecase.auth(
        params: AuthenticationParams(email: _email, password: _password),
      );
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      isLoading = false;
      mainError = null;
      switch (error) {
        case DomainError.unexpected:
          mainError = UIError.unexpected;
          break;
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
    }
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email');
    validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password');
    validateForm();
  }

  UIError _validateField({String field}) {
    final formData = {
      'email': _email,
      'password': _password,
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.requiredField;
      case ValidationError.invalidField:
        return UIError.invalidField;
      default:
        return null;
    }
  }

  void validateForm() {
    isFormValid = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  void goToSignUp() {
    navigateTo = '/signup';
  }
}
