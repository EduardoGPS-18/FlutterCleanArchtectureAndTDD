import 'package:get/get.dart';

mixin FormManager on GetxController {
  var _isFormValid = RxBool(false);
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool isValid) => _isFormValid.value = isValid;
}
