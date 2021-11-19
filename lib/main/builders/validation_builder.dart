import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

class ValidationBuilder {
  List<FieldValidation> _validations = [];
  String fieldName;

  ValidationBuilder._();

  static ValidationBuilder _instance;
  static ValidationBuilder field(String fieldName) {
    if (_instance == null) {
      _instance = ValidationBuilder._();
    }
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(fieldName));
    return this;
  }

  List<FieldValidation> build() {
    final validations = [..._validations];
    _validations.clear();
    return validations;
  }
}
