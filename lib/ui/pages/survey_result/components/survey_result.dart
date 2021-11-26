import 'package:flutter/material.dart';

import '../survey_result_viewmodel.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: Text(viewModel.question),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(90),
            ),
          );
        }
        final currentAnswer = viewModel.answers[index - 1];
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    'http://fordevs.herokuapp.com/static/img/logo-angular.png',
                    width: 40,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        currentAnswer.answer,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Text(
                    currentAnswer.percent,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  currentAnswer.isCurrentAnswer ? ActiveIcon() : InactiveIcon(),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }
}

class ActiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}

class InactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}
