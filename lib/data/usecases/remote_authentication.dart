import 'package:app_curso_manguinho/domain/domain.dart';
import 'package:meta/meta.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth({@required AuthenticationParams authParams}) async {
    final body = RemoteAuthenticationParams.fromDomain(authParams).toJson;
    await httpClient.request(
      url: this.url,
      method: 'post',
      body: body,
    );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map get toJson => {'email': email, 'password': password};
}
