import 'package:get/get.dart';

mixin LoadingManager on GetxController {
  var _isLoading = RxBool(false);

  Stream<bool> get isLoadingStream => _isLoading.stream;

  set isLoading(bool isLoading) => _isLoading.value = isLoading;
}
