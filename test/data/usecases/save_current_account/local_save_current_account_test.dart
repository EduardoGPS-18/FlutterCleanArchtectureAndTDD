import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;
  LocalSaveCurrentAccount({
    @required this.saveSecureCacheStorage,
  });
  @override
  Future<void> save(AccountEntity account) async {
    try {
      saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } on Exception {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

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
