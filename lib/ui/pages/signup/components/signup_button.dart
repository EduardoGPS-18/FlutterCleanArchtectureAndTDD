import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../signup.dart';
import '../../../helpers/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.hasData && snapshot.data == true ? presenter.signUp : null,
          child: Text(R.strings.login),
        );
      },
    );
  }
}
