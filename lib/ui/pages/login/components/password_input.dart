import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login.dart';

import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/i18n.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            errorText: snapshot.hasData ? snapshot.data.description : null,
            labelText: R.strings.password,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
        );
      },
    );
  }
}
