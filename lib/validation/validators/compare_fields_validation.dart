import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field, fieldToCompare;

  CompareFieldsValidation({
    required this.field,
    required this.fieldToCompare,
  });

  @override
  ValidationError? validate(Map input) {
    return input[field] != null && input[fieldToCompare] != null && input[field] != input[fieldToCompare]
        ? ValidationError.invalidField
        : null;
  }

  @override
  List<Object> get props => [fieldToCompare];
}
