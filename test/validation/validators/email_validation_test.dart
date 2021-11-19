import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String field) {
    return null;
  }
}

void main() {
  test('Should return null if email is empty', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate('');

    expect(error, null);
  });

  test('Should return null if email is null', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate('');

    expect(error, null);
  });
}
