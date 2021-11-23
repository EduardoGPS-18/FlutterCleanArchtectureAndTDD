import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field, valueToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.valueToCompare,
  });

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}
