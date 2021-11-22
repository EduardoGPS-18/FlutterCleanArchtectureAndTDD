import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;
    for (final validation in validations.where((validation) => validation.field == field)) {
      error = validation.validate(value);

      if (error?.isNotEmpty == true || error == null) {
        return error;
      }
    }
    return error;
  }
}
