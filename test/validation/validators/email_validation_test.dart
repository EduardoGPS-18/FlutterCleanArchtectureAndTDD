import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/validators/validators.dart';
import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';

void main() {
  FieldValidation sut;
  setUp(() {
    sut = EmailValidation('email');
  });

  test('Should return null on invalid case', () {
    expect(sut.validate({}), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'email': ''}), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate({'email': null}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'email': 'testeteste.com'}), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'email': 'teste@testecom'}), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'email': 'a@a'}), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'email': 'teste@teste.'}), ValidationError.invalidField);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'email': 'teste@teste@teste.com'}), ValidationError.invalidField);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'email': 'a@a.a'}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'email': 'teste@teste.com'}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'email': 'teste#\$%@teste.com'}), null);
  });
}
