import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

import 'package:app_curso_manguinho/main/decorators/decorators.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late Map body;
  late String url;
  late String method;
  late HttpClientSpy decoratee;
  late AuthorizedHttpClientDecorator sut;
  late SecureCacheStorageSpy secureCacheStorageSpy;

  late String token;
  late String httpResponse;

  setUp(() {
    decoratee = HttpClientSpy();
    secureCacheStorageSpy = SecureCacheStorageSpy();

    sut = AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: secureCacheStorageSpy,
      deleteSecureCacheStorage: secureCacheStorageSpy,
      decoratee: decoratee,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    httpResponse = faker.randomGenerator.string(50);
    decoratee.mockRequest<String>(httpResponse);

    token = faker.randomGenerator.string(50);
    secureCacheStorageSpy.mockFetchSecure(token);
  });

  test('Should call fetch secure storage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => secureCacheStorageSpy.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => decoratee.request(
          url: url,
          method: method,
          body: body,
          headers: {'x-access-token': token},
        )).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(() => decoratee.request(
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
    secureCacheStorageSpy.mockFetchSecureError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrow if decoratee throws and remove cached token', () async {
    decoratee.mockRequestError(HttpError.forbidden);

    Future future = sut.request(url: url, method: method, body: body);
    await untilCalled(() => secureCacheStorageSpy.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorageSpy.delete('token')).called(1);
  });

  test('Should cache if request throws forbidden error', () async {
    secureCacheStorageSpy.mockFetchSecureError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorageSpy.delete('token')).called(1);
  });
}
