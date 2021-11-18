import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/domain/domain.dart';

import 'package:app_curso_manguinho/data/data.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClient httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call http client with correct values', () async {
    final authParams = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
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
}
