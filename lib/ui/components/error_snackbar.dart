import 'package:flutter/material.dart';

void showErrorMessage({@required BuildContext context, @required String error}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[700],
      content: Text(error),
    ),
  );
}
