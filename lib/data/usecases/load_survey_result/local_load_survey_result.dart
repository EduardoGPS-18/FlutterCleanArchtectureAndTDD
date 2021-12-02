import '../../../domain/usecases/load_surveys_result.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';

import '../../models/models.dart';
import '../../cache/cache.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({
    required this.cacheStorage,
  });

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (_) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save(SurveyResultEntity surveyResult) async {
    try {
      await cacheStorage.save(
        key: 'survey_result/${surveyResult.surveyId}',
        value: LocalSurveyResultModel.fromEntity(surveyResult).toJson(),
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
