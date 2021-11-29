import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    final defaultheaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response> futureResponse;
    try {
      if (method == 'post') {
        futureResponse = client.post(url, headers: defaultheaders, body: jsonBody);
      } else if (method == 'get') {
        futureResponse = client.get(url, headers: defaultheaders);
      } else if (method == 'put') {
        futureResponse = client.put(url, headers: defaultheaders, body: jsonBody);
      }
      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 5));
      }
    } on Exception {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
