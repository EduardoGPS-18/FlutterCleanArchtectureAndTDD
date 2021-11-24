import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';

class AuthorizedHttpClientDecorator {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizedHttpClientDecorator({@required this.fetchSecureCacheStorage});
  Future<void> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  String url;
  String method;
  Map body;
  AuthorizedHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = AuthorizedHttpClientDecorator(fetchSecureCacheStorage: fetchSecureCacheStorageSpy);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
  });

  test('Should call fetch secure storage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
  });
}
