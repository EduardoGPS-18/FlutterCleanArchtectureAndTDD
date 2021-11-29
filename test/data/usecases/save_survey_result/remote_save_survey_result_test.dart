import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

class RemoteSaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> save({@required String answer}) async {
    try {
      await httpClient.request(url: url, method: 'put', body: {'answer': answer});
    } on HttpError catch (err) {
      throw err == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  String answer;
  HttpClient httpClient;
  RemoteSaveSurveyResult sut;

  PostExpectation mockHttpRequestCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));
  void mockHttpResponseError(HttpError httpError) => mockHttpRequestCall().thenThrow(httpError);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    answer = faker.lorem.sentence();

    sut = RemoteSaveSurveyResult(
      httpClient: httpClient,
      url: url,
    );
  });

  test('Should call httpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(httpClient.request(url: url, method: 'put', body: {'answer': answer})).called(1);
  });

  test('Should throw unexpected error if http client returns 404', () async {
    mockHttpResponseError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 500', () async {
    mockHttpResponseError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 403', () async {
    mockHttpResponseError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
