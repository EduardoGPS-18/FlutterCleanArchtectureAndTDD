import 'package:flutter/material.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel _surveyViewModel;

  const SurveyItem(this._surveyViewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _surveyViewModel.didAnswer ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColorDark,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              spreadRadius: 0,
              blurRadius: 2,
              color: Colors.black,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _surveyViewModel.date,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _surveyViewModel.question,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
