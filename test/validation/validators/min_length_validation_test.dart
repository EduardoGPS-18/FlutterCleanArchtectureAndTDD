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
    return ValidationError.invalidField;
  }
}

void main() {
  FieldValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 3);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}
