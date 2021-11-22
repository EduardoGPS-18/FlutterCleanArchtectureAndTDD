import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/data/cache/cache.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  SaveSecureCacheStorage saveSecureCacheStorage;
  SaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  PostExpectation mockSaveSecureCall() => when(saveSecureCacheStorage.saveSecure(
        key: anyNamed('key'),
        value: anyNamed('value'),
      ));
  void mockSaveSecureError() => mockSaveSecureCall().thenThrow(Exception());

  test('Should call save secure cache storage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw unexpected error if save secure cache storage with correct values', () async {
    mockSaveSecureError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
