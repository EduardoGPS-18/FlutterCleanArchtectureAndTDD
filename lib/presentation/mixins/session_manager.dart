import 'package:get/get.dart';

mixin SessionManager on GetxController {
  Rx<bool> _isSessionExpiredController = Rx(false);

  Stream<bool> get isSessionExpiredStream => _isSessionExpiredController.stream;

  set isSessionExpired(bool sessionExpired) => _isSessionExpiredController.value = sessionExpired;
}
