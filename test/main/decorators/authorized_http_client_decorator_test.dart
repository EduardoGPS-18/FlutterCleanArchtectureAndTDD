import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/data/http/http.dart';
import 'package:app_curso_manguinho/data/cache/cache.dart';

import 'package:app_curso_manguinho/main/decorators/decorators.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock implements DeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  String method;
  Map body;
  HttpClient decoratee;
  AuthorizedHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;
  DeleteSecureCacheStorage deleteSecureCacheStorageSpy;

  String token;
  String httpResponse;

  PostExpectation mockTokenCall() => when(fetchSecureCacheStorageSpy.fetch(any));
  PostExpectation mockHttpResponseCall() => when(decoratee.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }

  setUp(() {
    decoratee = HttpClientSpy();
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    deleteSecureCacheStorageSpy = DeleteSecureCacheStorageSpy();

    sut = AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
      deleteSecureCacheStorage: deleteSecureCacheStorageSpy,
      decoratee: decoratee,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call fetch secure storage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorageSpy.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(decoratee.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(decoratee.request(
      url: url,
      method: method,
      body: body,
      headers: {
        'x-access-token': token,
        'any_header': 'any_value',
      },
    )).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method);

    expect(response, httpResponse);
  });

  test('Should throw forbidden error if fetch secure cache storage throws', () async {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrow if decoratee throws and remove cached token', () async {
    mockHttpResponseError(HttpError.forbidden);

    Future future = sut.request(url: url, method: method, body: body);
    await untilCalled(deleteSecureCacheStorageSpy.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorageSpy.delete('token')).called(1);
  });

  test('Should cache if request throws forbidden error', () async {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorageSpy.delete('token')).called(1);
  });
}
