import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxSignUpPresenter extends GetxController
    with NavigateManager, FormManager, LoadingManager, MainErrorManager
    implements SignUpPresenter {
  final Validation validation;
  final SaveCurrentAccount saveCurrentAccount;
  final AddAccount addAccount;

  String _email, _name, _password, _confirmPassword;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _confirmPasswordError = Rx<UIError>();

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get confirmPasswordErrorStream => _confirmPasswordError.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  Future<AccountEntity> signUp() async {
    try {
      isLoading = true;
      final account = await addAccount.add(
        params: AddAccountParams(
          name: _name,
          email: _email,
          password: _password,
          passwordConfirmation: _confirmPassword,
        ),
      );
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
      return account;
    } on DomainError catch (error) {
      mainError = null;
      mainError = error == DomainError.emailInUse ? UIError.emailInUse : UIError.unexpected;
      isLoading = false;
    }
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    validateForm();
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    validateForm();
  }

  void validateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _confirmPasswordError.value = _validateField(field: 'confirmPassword', value: confirmPassword);
    validateForm();
  }

  UIError _validateField({String field, String value}) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'confirmPassword': _confirmPassword,
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
    isFormValid = _confirmPasswordError.value == null &&
        _passwordError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null &&
        _name != null &&
        _confirmPassword != null;
  }

  void goToLogin() => navigateTo = '/login';
}
