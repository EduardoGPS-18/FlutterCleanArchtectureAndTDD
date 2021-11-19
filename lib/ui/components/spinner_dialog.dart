import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Aguarde...',
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
