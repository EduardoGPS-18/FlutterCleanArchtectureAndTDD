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
    for (final validation in validations) {
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

  void mockValidations({String error1, String error2, String error3}) {
    when(validation1.validate(any)).thenReturn(error1 ?? null);
    when(validation2.validate(any)).thenReturn(error2 ?? '');
    when(validation3.validate(any)).thenReturn(error3 ?? '');
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    validation3 = FieldValidationSpy();
    when(validation2.field).thenReturn('other_field');
    mockValidations();
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validation returns null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidations(error1: 'error_1', error2: 'error_2', error3: 'error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_1');
  });
}
