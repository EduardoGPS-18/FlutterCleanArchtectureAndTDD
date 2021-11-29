import 'package:get/get.dart';

mixin NavigateManager on GetxController {
  var _navigateTo = Rx<String>();

  Stream<String> get navigateToStream => _navigateTo.stream;

  set navigateTo(String path) => _navigateTo.subject.add(path);
}
