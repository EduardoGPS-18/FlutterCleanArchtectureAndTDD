import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

import '../mixins/mixins.dart';

import '../../ui/pages/splash/splash.dart';

class GetxSplashPresenter extends GetxController with NavigateManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({
    required this.loadCurrentAccount,
  });

  @override
  Future<void> checkCurrentAccount({required int durationInSeconds}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      await loadCurrentAccount.load();
      navigateTo = '/surveys';
    } on Exception {
      navigateTo = '/login';
    }
  }
}
