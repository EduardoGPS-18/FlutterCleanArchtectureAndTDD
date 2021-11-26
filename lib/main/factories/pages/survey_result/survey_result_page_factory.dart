import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import 'survey_result_presenter_factory.dart';

Widget makeSurveyResultPage() {
  final surveyId = Get.parameters['survey_id'];

  return SurveyResultPage(
    presenter: makeSurveyResultPresenter(surveyId),
  );
}
