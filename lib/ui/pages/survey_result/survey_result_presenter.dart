import 'package:app_curso_manguinho/ui/pages/pages.dart';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> isLoading;
  Stream<dynamic> surveysData;
}
