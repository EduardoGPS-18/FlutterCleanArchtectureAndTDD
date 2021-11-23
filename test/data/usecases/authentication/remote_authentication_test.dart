import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

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

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation _mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));
  void mockHttpData(Map data) => _mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError error) => _mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authParams = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call http client with correct values', () async {
    await sut.auth(params: authParams);

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
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params: authParams);

    expect(account.token, validData['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
