import 'package:flutter/material.dart';

import 'components.dart';
import '../survey_answer_view_model.dart';

class SurveyResultAnswer extends StatelessWidget {
  const SurveyResultAnswer({required this.answer});

  final SurveyAnswerViewModel answer;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      return [
        if (answer.image != null)
          Image.network(
            answer.image!,
            width: 40,
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              answer.answer,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Text(
          answer.percent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        answer.isCurrentAnswer ? ActiveIcon() : InactiveIcon(),
      ];
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
