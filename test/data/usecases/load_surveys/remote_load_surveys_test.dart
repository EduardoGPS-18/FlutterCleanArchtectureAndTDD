import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/data/models/models.dart';
import 'package:app_curso_manguinho/data/http/http.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient<List<Map<dynamic, dynamic>>> httpClient;
  final String url;

  RemoteLoadSurveys({
    @required this.httpClient,
    @required this.url,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse.map((e) => RemoteSurveyModel.fromJson(e).toEntity()).toList();
    } on HttpError catch (err) {
      throw DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map<dynamic, dynamic>>> {}

void main() {
  HttpClient httpClient;
  String url;
  RemoteLoadSurveys sut;
  List<Map> listValidData;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didiAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didiAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  PostExpectation mockHttpRequestCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));
  void mockHttpResponseData(List<Map> data) => mockHttpRequestCall().thenAnswer((_) async => data);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );
    listValidData = mockValidData();
    mockHttpResponseData(listValidData);
  });

  test('Should call httpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: listValidData[0]['id'],
        question: listValidData[0]['question'],
        dateTime: DateTime.parse(listValidData[0]['date']),
        didAnswer: listValidData[0]['didAnswer'],
      ),
      SurveyEntity(
        id: listValidData[1]['id'],
        question: listValidData[1]['question'],
        dateTime: DateTime.parse(listValidData[1]['date']),
        didAnswer: listValidData[1]['didAnswer'],
      ),
    ]);
  });

  test('Should throw unexpected error if http client returns 200 with invalid data', () async {
    mockHttpResponseData([
      {'invalid_key': 'invalid_data'}
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
