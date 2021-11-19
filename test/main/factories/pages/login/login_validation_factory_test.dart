import 'package:app_curso_manguinho/main/builders/builders.dart';
import 'package:app_curso_manguinho/main/factories/pages/login/login_validation_factory.dart';
import 'package:app_curso_manguinho/validation/protocols/field_validation.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the correct validations', () async {
    final validations = makeLoginValidations();
    expect(validations, <FieldValidation>[
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}
