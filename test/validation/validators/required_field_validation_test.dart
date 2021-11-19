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
  FieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });
}
