import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/i18n/i18n.dart';
import '../../../helpers/errors/errors.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            errorText: snapshot.data?.description,
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
