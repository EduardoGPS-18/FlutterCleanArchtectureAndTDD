import '../../../../domain/usecases/authentication.dart';

import '../../../../data/usecases/usecases.dart';

import '../../../../main/factories/http/api_url_factory.dart';
import '../../../../main/factories/http/http_client_factory.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
