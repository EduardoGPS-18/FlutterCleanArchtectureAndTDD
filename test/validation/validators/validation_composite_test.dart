import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;
  ValidationComposite sut;

  void mockValidationsResponse({ValidationError error1, ValidationError error2, ValidationError error3}) {
    when(validation1.validate(any)).thenReturn(error1);
    when(validation2.validate(any)).thenReturn(error2);
    when(validation3.validate(any)).thenReturn(error3);
  }

  void mockValidationsField({String field1, String field2, String field3}) {
    when(validation1.field).thenReturn(field1 ?? 'any_field');
    when(validation2.field).thenReturn(field2 ?? 'any_field');
    when(validation2.field).thenReturn(field3 ?? 'other_field');
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    mockValidationsResponse();
    mockValidationsField();
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validation returns null or empty', () {
    final error = sut.validate(field: 'any_field', input: {});

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidationsResponse(
      error1: ValidationError.invalidField,
      error2: ValidationError.requiredField,
      error3: ValidationError.requiredField,
    );

    final error = sut.validate(field: 'any_field', input: {});

    expect(error, ValidationError.invalidField);
  });

  test('Should return the first error of the same field', () {
    mockValidationsResponse(
      error1: ValidationError.invalidField,
      error2: ValidationError.requiredField,
      error3: ValidationError.invalidField,
    );
    mockValidationsField(
      field1: 'any_field',
      field2: 'other_field',
      field3: 'other_field',
    );

    final error = sut.validate(field: 'other_field', input: {});

    expect(error, ValidationError.requiredField);
  });
}
