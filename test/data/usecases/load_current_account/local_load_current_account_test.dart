import 'package:app_curso_manguinho/domain/entities/account_entity.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({
    @required this.fetchSecureCacheStorage,
  });

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    return AccountEntity(token: token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheStorage.fetchSecure(any));
  void mockFetchSecureSuccess() => mockFetchSecureCall().thenAnswer((_) async => token);

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
}
