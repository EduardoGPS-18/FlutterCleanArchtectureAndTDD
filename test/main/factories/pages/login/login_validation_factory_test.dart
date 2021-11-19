import 'package:app_curso_manguinho/main/factories/pages/login/login_validation_factory.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the correct validations', () async {
    final validations = makeLoginValidations();
    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}
