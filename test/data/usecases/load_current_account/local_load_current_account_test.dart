import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/domain/entities/account_entity.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheStorage.fetchSecure(any));
  void mockFetchSecureSuccess() => mockFetchSecureCall().thenAnswer((_) async => token);
  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecureSuccess();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an Account Entity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCachedStorage throws', () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
