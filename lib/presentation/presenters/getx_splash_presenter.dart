import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

import '../../ui/pages/splash/splash.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({
    @required this.loadCurrentAccount,
  });

  var _navigateTo = RxString();
  @override
  Stream<String> get navigateStream => _navigateTo.stream;

  @override
  Future<void> checkCurrentAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();

      return _navigateTo.value = account?.token == null ? '/login' : '/surveys';
    } on Exception {
      return _navigateTo.value = '/login';
    }
  }
}
