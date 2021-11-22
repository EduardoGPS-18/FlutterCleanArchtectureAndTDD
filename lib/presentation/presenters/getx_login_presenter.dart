import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';

import '../../presentation/protocols/protocols.dart';

import '../../ui/pages/login/login.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authenticationUsecase;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = RxString();
  var _mainError = RxString();
  var _passwordError = RxString();
  var _navigateTo = RxString();
  var _isLoading = RxBool(false);
  var _isFormValid = RxBool(false);

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

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
      _mainError.value = error.description;
    }
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(field: 'password', value: password);
    validateForm();
  }

  void validateForm() {
    _isFormValid.value = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  void dispose() {}
}
