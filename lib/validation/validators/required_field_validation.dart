import 'package:equatable/equatable.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }

  @override
  List<Object> get props => [field];
}
