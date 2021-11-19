import 'package:meta/meta.dart';
import 'dart:async';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

class LoginState {
  String emailError;
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;

  var _state = LoginState();

  StreamController<LoginState> _controller = StreamController.broadcast();
  Stream<String> get emailErrorStream => _controller.stream
      .map(
        (state) => state.emailError,
      )
      .distinct();
  Stream<bool> get isFormValidStream => _controller.stream
      .map(
        (state) => state.isFormValid,
      )
      .distinct();

  StreamLoginPresenter({
    @required this.validation,
  });

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}
