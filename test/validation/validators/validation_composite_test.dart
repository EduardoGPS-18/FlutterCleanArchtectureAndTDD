import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;
    for (final validation in validations.where((validation) => validation.field == field)) {
      error = validation.validate(value);

      if (error?.isNotEmpty == true || error == null) {
        return error;
      }
    }
    return error;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;
  ValidationComposite sut;

  void mockValidationsResponse({String error1, String error2, String error3}) {
    when(validation1.validate(any)).thenReturn(error1 ?? null);
    when(validation2.validate(any)).thenReturn(error2 ?? '');
    when(validation3.validate(any)).thenReturn(error3 ?? '');
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
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidationsResponse(error1: 'error_1', error2: 'error_2', error3: 'error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_1');
  });

  test('Should return the first error of the same field', () {
    mockValidationsResponse(error1: 'error_1', error2: 'error_2', error3: 'error_3');
    mockValidationsField(field1: 'any_field', field2: 'other_field', field3: 'other_field');

    final error = sut.validate(field: 'other_field', value: 'any_value');

    expect(error, 'error_2');
  });
}
