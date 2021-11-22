import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login.dart';

import '../../../../utils/i18n/i18n.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          child: Text(R.strings.login),
        );
      },
    );
  }
}
