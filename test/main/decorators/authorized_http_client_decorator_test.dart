import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';

class AuthorizedHttpClientDecorator {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizedHttpClientDecorator({@required this.fetchSecureCacheStorage});
  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  test('Should call fetch secure storage with correct key', () async {
    final fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    final sut = AuthorizedHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheStorageSpy);

    await sut.request();

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
  });
}
