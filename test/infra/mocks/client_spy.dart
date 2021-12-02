import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    mockPost(200);
    mockGet(200);
    mockPut(200);
  }

  When mockPostCall() => when(
        () => this.post(any(), body: any(named: 'body'), headers: any(named: 'headers')),
      );
  void mockPostError() => mockPostCall().thenThrow(Exception());
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  }

  When mockGetCall() => when(() => this.get(any(), headers: any(named: 'headers')));
  void mockGetError() => mockGetCall().thenThrow(Exception());
  void mockGet(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockGetCall().thenAnswer((_) async => Response(body, statusCode));
  }

  When mockPutCall() => when(
        () => this.put(any(), body: any(named: 'body'), headers: any(named: 'headers')),
      );
  void mockPutError() => mockPutCall().thenThrow(Exception());
  void mockPut(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockPutCall().thenAnswer((_) async => Response(body, statusCode));
  }
}
