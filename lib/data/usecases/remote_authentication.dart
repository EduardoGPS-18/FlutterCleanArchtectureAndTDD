import 'package:meta/meta.dart';

import '../../domain/domain.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth({@required AuthenticationParams authParams}) async {
    await httpClient.request(
      url: this.url,
      method: 'post',
      body: authParams.toJson,
    );
  }
}
