import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/main/composites/composites.dart';

import '../../validation/mocks/mocks.dart';

void main() {
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;
  late ValidationComposite sut;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validation returns null or empty', () {
    final error = sut.validate(field: 'any_field', input: {});

    expect(error, null);
  });

  test('Should return the first error', () {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.requiredField);

    final error = sut.validate(field: 'any_field', input: {});

    expect(error, ValidationError.invalidField);
  });

  test('Should return the first error of the same field', () {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);

    validation2.mockFieldName('other_field');
    validation3.mockFieldName('other_field');

    final error = sut.validate(field: 'other_field', input: {});

    expect(error, ValidationError.requiredField);
  });
}
