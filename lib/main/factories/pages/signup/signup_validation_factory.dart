import '../../../../validation/protocols/protocols.dart';

import '../../../builders/builders.dart';

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(8).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(8).build(),
    ...ValidationBuilder.field('confirmPassword').required().min(8).sameAs('password').build(),
  ];
}
