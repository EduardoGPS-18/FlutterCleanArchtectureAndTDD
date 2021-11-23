import '../i18n/i18n.dart';

enum UIError {
  unexpected,
  requiredField,
  invalidField,
  invalidCredentials,
  emailInUse,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.unexpected:
        return R.strings.unexpected;
      case UIError.requiredField:
        return R.strings.requiredField;
      case UIError.invalidField:
        return R.strings.invalidField;
      case UIError.invalidCredentials:
        return R.strings.invalidCredentials;
      case UIError.emailInUse:
        return R.strings.emailInUse;
      default:
        return R.strings.unexpected;
    }
  }
}
