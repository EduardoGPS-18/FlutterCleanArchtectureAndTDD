import 'package:meta/meta.dart';

abstract class HttpClient<RESPONSE_TYPE> {
  Future<RESPONSE_TYPE> request({
    @required String url,
    @required String method,
    Map body,
  });
}
