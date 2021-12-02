import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/http_client_spy.dart';

void main() {
  late String url;
  late List<Map> data;
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );

    data = ApiFactory.makeSurveys();
    httpClient.mockRequest(data);
  });

  test('Should call httpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
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
    httpClient.mockRequest(ApiFactory.makeSurveysWithIncompleteData());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
