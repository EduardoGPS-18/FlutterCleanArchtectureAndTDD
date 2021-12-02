import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

import '../../models/models.dart';
import '../../../domain/helpers/helpers.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({
    required this.httpClient,
    required this.url,
  });

  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final json = await httpClient.request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (err) {
      throw err == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
