import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteLoadSurveyResult sut;
  late Map<String, dynamic> surveyResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveyResult(
      httpClient: httpClient,
      url: url,
    );
    surveyResult = ApiFactory.makeSurveyResultJson();
    httpClient.mockRequest(surveyResult);
  });

  test('Should call httpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return surveys on 200', () async {
    final result = await sut.loadBySurvey();

    final expectedReturn = SurveyResultEntity(
      surveyId: surveyResult['surveyId'],
      question: surveyResult['question'],
      answers: [
        SurveyAnswerEntity(
          answer: surveyResult['answers'][0]['answer'],
          isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][0]['percent'],
          image: surveyResult['answers'][0]['image'],
        ),
        SurveyAnswerEntity(
          answer: surveyResult['answers'][1]['answer'],
          isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][1]['percent'],
        ),
      ],
    );

    expect(result, expectedReturn);
  });

  test('Should throw unexpected error if http client returns 200 with invalid data', () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpected error if http client returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
