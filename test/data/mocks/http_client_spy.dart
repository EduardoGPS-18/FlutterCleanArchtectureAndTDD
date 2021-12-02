import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {
  When _mockRequestCall() => when(() => request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ));
  void mockRequest<T>(T data) => _mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) => _mockRequestCall().thenThrow(error);
}
