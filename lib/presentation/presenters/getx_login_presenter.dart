import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/domain_error.dart';

import '../../presentation/protocols/protocols.dart';

import '../../ui/pages/login/login.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authenticationUsecase;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _navigateTo = Rx<String>();
  var _isLoading = RxBool(false);
  var _isFormValid = RxBool(false);

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authenticationUsecase,
    @required this.saveCurrentAccount,
  });

  Future<void> auth() async {
    try {
      _isLoading.value = true;
      final account = await authenticationUsecase.auth(
        params: AuthenticationParams(email: _email, password: _password),
      );
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _isLoading.value = false;
      _mainError.value = null;
      switch (error) {
        case DomainError.unexpected:
          _mainError.value = UIError.unexpected;
          break;
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
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
    _isFormValid.value = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}
