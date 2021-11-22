enum UIError {
  unexpected,
  requiredField,
  invalidField,
  invalidCredentials,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.unexpected:
        return 'Error inesperado';
      case UIError.requiredField:
        return 'Campo obrigatório';
      case UIError.invalidField:
        return 'Campo inválido';
      case UIError.invalidCredentials:
        return 'Credenciais inválidas';
    }
  }
}
