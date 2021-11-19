import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;

  var _state = LoginState();

  StreamController<LoginState> _controller = StreamController.broadcast();
  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({
    @required this.validation,
  });

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  Validation validation;
  String email;

  PostExpectation mockValidationCall([String field]) => when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        value: anyNamed('value'),
      ));
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}
