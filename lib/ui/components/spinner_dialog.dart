import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

Future<void> showLoading(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              R.strings.wait,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
