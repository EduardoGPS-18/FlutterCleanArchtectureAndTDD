import 'package:flutter/material.dart';

import '../survey_result_viewmodel.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return SurveyResultHeader(question: viewModel.question);
        }
        final currentAnswer = viewModel.answers[index - 1];
        return SurveyResultAnswer(answer: currentAnswer);
      },
    );
  }
}
