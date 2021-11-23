import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/presentation/protocols/validation.dart';
import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(String value) {
    return value != null && value.length >= size ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, size];
}
