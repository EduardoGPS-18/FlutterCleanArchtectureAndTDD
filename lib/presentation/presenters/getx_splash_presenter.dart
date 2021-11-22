import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({
    @required this.loadCurrentAccount,
  });

  var _navigateTo = RxString();
  @override
  Stream<String> get navigateStream => _navigateTo.stream;

  @override
  Future<void> checkCurrentAccount() async {
    try {
      final account = await loadCurrentAccount.load();

      return _navigateTo.value = account.isNull ? '/login' : '/surveys';
    } on Exception {
      return _navigateTo.value = '/login';
    }
  }
}
