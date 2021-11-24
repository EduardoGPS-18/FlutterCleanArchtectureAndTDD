import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({
    @required this.httpClient,
    @required this.url,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse.map<SurveyEntity>((e) => RemoteSurveyModel.fromJson(e).toEntity()).toList();
    } on HttpError catch (err) {
      throw err == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
