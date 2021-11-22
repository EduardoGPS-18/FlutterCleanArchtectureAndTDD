import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  RequiredFieldValidation(this.field);

  @override
  ValidationError validate(String value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];
}
