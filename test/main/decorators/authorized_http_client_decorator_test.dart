import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';
import 'package:app_curso_manguinho/data/http/http.dart';

class AuthorizedHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizedHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });
  Future<void> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = {
      'x-access-token': token,
    };
    await decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  String method;
  Map body;
  HttpClient httpClient;
  AuthorizedHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  String token;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheStorageSpy.fetchSecure(any)).thenAnswer((_) async => token);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();

    sut = AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
      decoratee: httpClient,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
  });

  test('Should call fetch secure storage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);

    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);
  });
}
