import 'package:meta/meta.dart';
import 'dart:async';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

class LoginState {
  String email;
  String emailError;
  String password;
  String passwordError;
  bool isLoading = false;
  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authenticationUsecase;

  var _state = LoginState();

  StreamController<LoginState> _controller = StreamController.broadcast();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authenticationUsecase,
  });

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    await authenticationUsecase.auth(
      params: AuthenticationParams(email: _state.email, password: _state.password),
    );
    _state.isLoading = false;
    _update();
  }

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }
}
