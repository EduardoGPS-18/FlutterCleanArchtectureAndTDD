import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

class RemoteLoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call httpClient with correct values', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );

    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
