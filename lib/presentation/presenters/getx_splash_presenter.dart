import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';

import '../mixins/mixins.dart';

import '../../ui/pages/splash/splash.dart';

class GetxSplashPresenter extends GetxController with NavigateManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({
    @required this.loadCurrentAccount,
  });

  @override
  Future<void> checkCurrentAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();

      return navigateTo = account?.token == null ? '/login' : '/surveys';
    } on Exception {
      return navigateTo = '/login';
    }
  }
}
