import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

void main() {
  late FieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate({'field': 'any_value'}), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate({'field': ''}), ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'field': null}), ValidationError.requiredField);
  });
}
