import 'package:app_curso_manguinho/presentation/protocols/validation.dart';
import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

import 'package:meta/meta.dart';

class MinLengthValidation implements FieldValidation {
  @override
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(String value) {
    return null;
  }
}

void main() {
  test('Should return error if value is empty', () {
    final sut = MinLengthValidation(field: 'any_field', size: 3);

    final error = sut.validate('');
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final sut = MinLengthValidation(field: 'any_field', size: 3);

    final error = sut.validate(null);
    expect(error, ValidationError.invalidField);
  });
}
