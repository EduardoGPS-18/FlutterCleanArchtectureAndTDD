import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

void main() {
  FieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.requiredField);
  });
}
