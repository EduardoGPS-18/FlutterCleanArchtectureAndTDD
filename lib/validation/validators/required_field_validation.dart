import 'package:app_curso_manguinho/validation/protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  String field;
  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}
