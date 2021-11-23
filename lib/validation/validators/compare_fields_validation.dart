import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field, fieldToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.fieldToCompare,
  });

  @override
  ValidationError validate(Map input) {
    return input[field] != null && input[fieldToCompare] != null && input[field] != input[fieldToCompare]
        ? ValidationError.invalidField
        : null;
  }
}
