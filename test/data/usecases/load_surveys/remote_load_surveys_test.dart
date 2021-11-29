import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

import '../../../mocks/fake_surveys_factory.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClient httpClient;
  String url;
  RemoteLoadSurveys sut;
  List<Map> data;

  PostExpectation mockHttpRequestCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));
  void mockHttpResponseData(List<Map> list) {
    data = list;
    mockHttpRequestCall().thenAnswer((_) async => list);
  }

  void mockHttpResponseError(HttpError httpError) => mockHttpRequestCall().thenThrow(httpError);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );
    mockHttpResponseData(FakeSurveysFactory.makeApiJson());
  });

  test('Should call httpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: data[0]['id'],
        question: data[0]['question'],
        dateTime: DateTime.parse(data[0]['date']),
        didAnswer: data[0]['didAnswer'],
      ),
      SurveyEntity(
        id: data[1]['id'],
        question: data[1]['question'],
        dateTime: DateTime.parse(data[1]['date']),
        didAnswer: data[1]['didAnswer'],
      ),
    ]);
  });

  test('Should throw unexpected error if http client returns 200 with invalid data', () async {
    mockHttpResponseData(FakeSurveysFactory.makeInvalidApiJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 404', () async {
    mockHttpResponseError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 500', () async {
    mockHttpResponseError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 403', () async {
    mockHttpResponseError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
