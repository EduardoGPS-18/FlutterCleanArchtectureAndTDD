import 'package:test/test.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

import 'package:app_curso_manguinho/main/factories/pages/login/login.dart';

void main() {
  test('Should return the correct validations', () async {
    final validations = makeLoginValidations();
    expect(validations, <FieldValidation>[
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
    ]);
  });
}
