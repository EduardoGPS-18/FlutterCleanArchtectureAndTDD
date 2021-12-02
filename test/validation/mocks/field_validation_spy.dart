import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/validation/protocols/protocols.dart';
import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FieldValidation {
  FieldValidationSpy() {
    mockValidation();
    mockFieldName('any_field');
  }
  When mockValidationCall() => when(() => this.validate(any()));
  void mockValidation() => mockValidationCall().thenReturn(null);
  void mockValidationError(ValidationError error1) => mockValidationCall().thenReturn(error1);

  When mockFieldNameCall() => when(() => this.field);
  void mockFieldName(String name) => mockFieldNameCall().thenReturn(name);
}
