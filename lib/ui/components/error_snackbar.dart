import 'package:flutter/material.dart';

void showErrorMessage({@required GlobalKey<ScaffoldState> scaffoldKey, @required String error}) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[700],
      content: Text(error),
    ),
  );
}
