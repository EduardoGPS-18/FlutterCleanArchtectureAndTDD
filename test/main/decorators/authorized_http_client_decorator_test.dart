import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';
import 'package:app_curso_manguinho/data/http/http.dart';

class AuthorizedHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizedHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = (headers ?? {})..addAll({'x-access-token': token});
      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
    } on Exception {
      throw HttpError.forbidden;
    } on HttpError {
      rethrow;
    }
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  String method;
  Map body;
  HttpClient decoratee;
  AuthorizedHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;

  String token;
  String httpResponse;

  PostExpectation mockTokenCall() => when(fetchSecureCacheStorageSpy.fetchSecure(any));
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

    sut = AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
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

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
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

  test('Should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);
    expect(future, throwsA(HttpError.badRequest));

    mockHttpResponseError(HttpError.serverError);
    final future2 = sut.request(url: url, method: method, body: body);
    expect(future2, throwsA(HttpError.serverError));
  });
}
