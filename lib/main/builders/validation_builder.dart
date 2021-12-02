import '../../validation/validators/validators.dart';
import '../../validation/protocols/protocols.dart';

class ValidationBuilder {
  String fieldName;
  List<FieldValidation> _validations = [];

  ValidationBuilder._(this.fieldName);

  static ValidationBuilder? _instance;
  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._(fieldName);
    return _instance!;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(fieldName));
    return this;
  }

  ValidationBuilder min(int size) {
    _validations.add(MinLengthValidation(field: fieldName, size: size));
    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    _validations.add(CompareFieldsValidation(field: fieldName, fieldToCompare: fieldToCompare));
    return this;
  }

  List<FieldValidation> build() {
    final validations = [..._validations];
    _validations.clear();
    return validations;
  }
}
