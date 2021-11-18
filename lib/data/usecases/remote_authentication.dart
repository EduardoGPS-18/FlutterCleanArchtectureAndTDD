import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<AccountEntity> auth({
    @required AuthenticationParams authParams,
  }) async {
    final body = RemoteAuthenticationParams.fromDomain(authParams).toJson;
    try {
      final httpResponse = await httpClient.request(
        url: this.url,
        method: 'post',
        body: body,
      );

      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      throw error == HttpError.anauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
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
