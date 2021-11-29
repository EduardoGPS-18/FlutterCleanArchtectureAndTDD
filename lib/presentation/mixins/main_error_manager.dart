import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:get/get.dart';

mixin MainErrorManager on GetxController {
  Stream<UIError> get mainErrorStream => _mainError.stream;
  var _mainError = Rx<UIError>();
  set mainError(UIError error) => _mainError.value = error;
}
