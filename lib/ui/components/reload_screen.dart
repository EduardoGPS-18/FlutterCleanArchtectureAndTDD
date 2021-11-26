import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({
    @required this.error,
    @required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            error,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: RaisedButton(
            onPressed: reload,
            child: Text(R.strings.reload),
          ),
        ),
      ],
    );
  }
}
