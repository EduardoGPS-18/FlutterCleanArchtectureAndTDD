import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:app_curso_manguinho/validation/validators/validators.dart';

Validation makeValidationComposite() => ValidationComposite([
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
