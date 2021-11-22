import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/domain/usecases/load_current_account.dart';
import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';

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
    await loadCurrentAccount.load();

    _navigateTo.value = '/surveys';
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  SplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkCurrentAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkCurrentAccount();
  });
}
