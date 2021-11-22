import 'package:meta/meta.dart';
import 'dart:async';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/domain_error.dart';

import '../../presentation/protocols/protocols.dart';

import '../../ui/pages/login/login.dart';

class LoginState {
  String email;
  String password;

  String emailError;
  String passwordError;
  String mainError;

  bool isLoading = false;
  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authenticationUsecase;

  var _state = LoginState();

  StreamController<LoginState> _controller = StreamController.broadcast();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();
  Stream<String> get mainErrorStream => _controller.stream.map((state) => state.mainError).distinct();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authenticationUsecase,
  });

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authenticationUsecase.auth(
        params: AuthenticationParams(email: _state.email, password: _state.password),
      );
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }
    _state.isLoading = false;
    _update();
  }

  void _update() {
    if (!_controller.isClosed) _controller.add(_state);
  }

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

  void dispose() {
    _controller.close();
  }
}
