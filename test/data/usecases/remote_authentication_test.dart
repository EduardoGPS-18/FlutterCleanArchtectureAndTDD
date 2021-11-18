import 'package:app_curso_manguinho/domain/usecases/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth({@required String url}) async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({@required String url, @required String method});
}

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
    await sut.auth(url: url);

    verify(httpClient.request(url: url, method: 'post'));
  });
}
