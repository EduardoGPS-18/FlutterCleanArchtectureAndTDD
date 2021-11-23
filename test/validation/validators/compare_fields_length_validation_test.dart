import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

void main() {
  FieldValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if value is not equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return null on invalid cases', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'other_value'}), null);
    expect(sut.validate({}), null);
  });

  test('Should return null if values are not equal', () {
    final formData = {
      'any_field': 'same_value',
      'other_field': 'same_value',
    };
    expect(sut.validate(formData), null);
  });
}
