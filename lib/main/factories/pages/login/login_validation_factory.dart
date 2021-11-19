import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

Validation makeValidationComposite() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ];
}
