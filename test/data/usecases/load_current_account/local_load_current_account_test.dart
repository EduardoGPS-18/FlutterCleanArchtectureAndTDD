import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/domain/entities/account_entity.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';

void main() {
  late String token;
  late LocalLoadCurrentAccount sut;
  late SecureCacheStorageSpy fetchSecureCacheStorage;

  setUp(() {
    fetchSecureCacheStorage = SecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);

    token = faker.guid.guid();
    fetchSecureCacheStorage.mockFetchSecure(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetch('token'));
  });

  test('Should return an Account Entity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCachedStorage throws', () async {
    fetchSecureCacheStorage.mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if FetchSecureCachedStorage returns null', () async {
    fetchSecureCacheStorage.mockFetchSecure(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
