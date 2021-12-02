import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

void main() {
  late FieldValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'field', size: 5);
  });

  test('Should return null on invalid case', () {
    expect(sut.validate({}), ValidationError.invalidField);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate({'field': ''}), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'field': null}), ValidationError.invalidField);
  });

  test('Should return error if value is less then min size', () {
    expect(sut.validate({'field': faker.randomGenerator.string(5, min: 1)}), ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate({'field': faker.randomGenerator.string(5, min: 5)}), null);
  });

  test('Should return null if value is bigger than min size', () {
    expect(sut.validate({'field': faker.randomGenerator.string(10, min: 6)}), null);
  });
}
