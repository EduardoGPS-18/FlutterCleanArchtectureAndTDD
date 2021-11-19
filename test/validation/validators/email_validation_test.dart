import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{ }~]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido';
  }
}

void main() {
  FieldValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('testeteste.com'), 'Campo inválido');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@testecom'), 'Campo inválido');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('a@a'), 'Campo inválido');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@teste.'), 'Campo inválido');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@teste@teste.com'), 'Campo inválido');
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('a@a.a'), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('teste@teste.com'), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('teste#\$%@teste.com'), null);
  });
}
