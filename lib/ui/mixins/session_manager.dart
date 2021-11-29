import 'package:meta/meta.dart';
import 'package:get/get.dart';

mixin SessionManager {
  void handleSession({@required Stream<bool> stream}) {
    stream.listen((isExpired) {
      if (isExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}
