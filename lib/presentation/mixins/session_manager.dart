import 'package:get/get.dart';

mixin SessionManager on GetxController {
  Rx<bool> _isSessionExpiredController = Rx();

  Stream<bool> get isSessionExpiredStream => _isSessionExpiredController.stream;

  set isSessionExpired(bool sessionExpired) => _isSessionExpiredController.value = sessionExpired;
}
