import 'package:flutter_test/flutter_test.dart';

import 'package:app_curso_manguinho/main/builders/builders.dart';
import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

void main() {
  test('validation builder ...', () {
    test('Should return for a single field but some validator', () async {
      final validations = ValidationComposite([
        ...ValidationBuilder.field('any_field').required().email().build(),
      ]);
      expect(validations.validations, <FieldValidation>[
        RequiredFieldValidation('any_field'),
        EmailValidation('any_field'),
      ]);
    });

    test('Should return two field validators but only one validator', () async {
      final validations = ValidationComposite([
        ...ValidationBuilder.field('any_field').required().build(),
        ...ValidationBuilder.field('other_field').required().build(),
      ]);
      expect(validations.validations, <FieldValidation>[
        RequiredFieldValidation('any_field'),
        RequiredFieldValidation('other_field'),
      ]);
    });
  });
}
