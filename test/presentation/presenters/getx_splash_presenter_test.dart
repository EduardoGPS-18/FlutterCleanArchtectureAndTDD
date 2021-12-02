import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late SplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    loadCurrentAccount.mockLoadCurrentAccount(EntityFactory.makeAccount());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkCurrentAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkCurrentAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    loadCurrentAccount.mockLoadCurrentAccountError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkCurrentAccount(durationInSeconds: 0);
  });
}
