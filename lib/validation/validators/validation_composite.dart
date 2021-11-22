import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;
    for (final validation in validations.where((validation) => validation.field == field)) {
      error = validation.validate(value);

      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
