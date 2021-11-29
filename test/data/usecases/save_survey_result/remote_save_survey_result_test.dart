import 'package:app_curso_manguinho/data/models/models.dart';
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

  Future<SurveyResultEntity> save({@required String answer}) async {
    try {
      final json = await httpClient.request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
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

  Map<String, dynamic> surveyResult;

  Map<String, dynamic> mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(50),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(50),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  PostExpectation mockHttpRequestCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));
  void mockHttpResponseData(Map<String, dynamic> data) {
    surveyResult = data;
    mockHttpRequestCall().thenAnswer((_) async => data);
  }

  void mockHttpResponseError(HttpError httpError) => mockHttpRequestCall().thenThrow(httpError);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    answer = faker.lorem.sentence();

    sut = RemoteSaveSurveyResult(
      httpClient: httpClient,
      url: url,
    );
    mockHttpResponseData(mockValidData());
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

  test('Should return surveys on 200', () async {
    final result = await sut.save(answer: answer);

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
    mockHttpResponseData({'invalid_key': 'invalid_data'});

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });
}
