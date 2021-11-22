import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

import '../../../../main/builders/builders.dart';

Validation makeValidationComposite() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
  ];
}
