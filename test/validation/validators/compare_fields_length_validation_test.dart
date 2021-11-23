import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/validators/validators.dart';
import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

void main() {
  FieldValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });

  test('Should return null if value are not equal', () {
    expect(sut.validate('any_value'), null);
  });
}
