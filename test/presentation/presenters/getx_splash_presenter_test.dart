import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';

import '../../mocks/mocks.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  SplashPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());
  void mockLoadCurrentAccount(AccountEntity account) => mockLoadCurrentAccountCall().thenAnswer((_) async => account);

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(FakeAccountFactory.makeEntity());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkCurrentAccount(durationInSeconds: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkCurrentAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkCurrentAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null token', () async {
    mockLoadCurrentAccount(AccountEntity(token: null));

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkCurrentAccount(durationInSeconds: 0);
  });
}
