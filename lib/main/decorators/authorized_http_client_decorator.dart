import 'package:meta/meta.dart';

import '../../data/http/http.dart';
import '../../data/cache/cache.dart';

class AuthorizedHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizedHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = (headers ?? {})..addAll({'x-access-token': token});
      final data = await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
      return data;
    } on HttpError {
      rethrow;
    } on Exception {
      throw HttpError.forbidden;
    }
  }
}
