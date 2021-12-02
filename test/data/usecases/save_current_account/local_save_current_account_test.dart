import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';

void main() {
  late AccountEntity account;
  late SaveCurrentAccount sut;
  late SecureCacheStorageSpy saveSecureCacheStorage;

  setUp(() {
    saveSecureCacheStorage = SecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  test('Should call save secure cache storage with correct values', () async {
    await sut.save(account);

    verify(() => saveSecureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw unexpected error if save secure cache storage with correct values', () async {
    saveSecureCacheStorage.mockSaveSecureError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
