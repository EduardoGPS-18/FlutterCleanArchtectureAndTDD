import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/data/http/http.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late String url;
  late Map apiResult;
  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;
  late AuthenticationParams authParams;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authParams = ParamsFactory.makeAuthentication();

    apiResult = ApiFactory.makeAccountJson();
    httpClient.mockRequest(apiResult);
  });

  test('Should call http client with correct values', () async {
    await sut.auth(params: authParams);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': authParams.email,
            'password': authParams.password,
          },
        ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {
    httpClient.mockRequestError(HttpError.unauthorized);

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final account = await sut.auth(params: authParams);

    expect(account.token, apiResult['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    final future = sut.auth(params: authParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
