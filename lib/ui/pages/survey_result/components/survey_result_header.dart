import 'package:flutter/material.dart';

class SurveyResultHeader extends StatelessWidget {
  final String question;
  const SurveyResultHeader({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      child: Text(question),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withAlpha(90),
      ),
    );
  }
}
