import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(Map input) {
    return input[field] != null && input[field].length >= size ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, size];
}
