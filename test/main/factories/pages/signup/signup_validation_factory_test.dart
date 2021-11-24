import 'package:test/test.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

import 'package:app_curso_manguinho/main/factories/factories.dart';

// ...ValidationBuilder.field('name').required().min(8).build(),
// ...ValidationBuilder.field('email').required().email().build(),
// ...ValidationBuilder.field('password').required().min(8).build(),
// ...ValidationBuilder.field('confirmPassword').required().min(8).sameAs('password').build(),
void main() {
  test('Should return the correct validations', () async {
    final validations = makeSignUpValidations();
    expect(validations, <FieldValidation>[
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 8),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 8),
      RequiredFieldValidation('confirmPassword'),
      MinLengthValidation(field: 'confirmPassword', size: 8),
      CompareFieldsValidation(field: 'confirmPassword', fieldToCompare: 'password'),
    ]);
  });
}
