import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field, fieldToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.fieldToCompare,
  });

  @override
  ValidationError validate(Map input) {
    return input[field] == input[fieldToCompare] ? null : ValidationError.invalidField;
  }
}
