import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

import '../../ui/helpers/errors/errors.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;

  String _email, _name, _password, _confirmPassword;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _confirmPasswordError = Rx<UIError>();
  var _isFormValid = RxBool(false);

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get confirmPasswordErrorStream => _confirmPasswordError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
  });

  Future<void> signUp() async {
    addAccount.add(
      params: AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _confirmPassword,
      ),
    );
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
    final error = validation.validate(field: field, value: value);
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
    _isFormValid.value = _confirmPasswordError.value == null &&
        _passwordError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null &&
        _name != null &&
        _confirmPassword != null;
  }
}
