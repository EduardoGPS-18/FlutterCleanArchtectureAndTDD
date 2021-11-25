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

    Response response = Response('', 500);
    try {
      if (method == 'post') {
        response = await client.post(
          url,
          headers: defaultheaders,
          body: jsonBody,
        );
      } else if (method == 'get') {
        response = await client.get(
          url,
          headers: defaultheaders,
        );
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
