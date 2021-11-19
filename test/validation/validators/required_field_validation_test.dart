import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  @override
  String field;
  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value.isNotEmpty ? null : 'Campo obrigatório';
  }
}

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation('any');

    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('Should return error if value is empty', () {
    final sut = RequiredFieldValidation('any');

    final error = sut.validate('');

    expect(error, 'Campo obrigatório');
  });
}
