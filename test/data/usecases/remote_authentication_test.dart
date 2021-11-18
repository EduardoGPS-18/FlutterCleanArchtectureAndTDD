import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';

import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClient httpClient;
  String url;
  AuthenticationParams authParams;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authParams = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('Should call http client with correct values', () async {
    await sut.auth(authParams: authParams);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': authParams.email,
        'password': authParams.password,
      },
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final future = sut.auth(authParams: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
