import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

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
    expect(sut.validate('testeteste.com'), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@testecom'), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('a@a'), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@teste.'), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste@teste@teste.com'), ValidationError.invalidField);
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
