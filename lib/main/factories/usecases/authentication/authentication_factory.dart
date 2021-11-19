import 'package:app_curso_manguinho/data/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/usecases/authentication.dart';
import 'package:app_curso_manguinho/main/factories/http/api_url_factory.dart';
import 'package:app_curso_manguinho/main/factories/http/http_client_factory.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
