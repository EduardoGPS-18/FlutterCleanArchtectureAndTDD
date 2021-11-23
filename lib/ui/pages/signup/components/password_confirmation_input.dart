import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/i18n.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.confirmPasswordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateConfirmPassword,
          decoration: InputDecoration(
            errorText: snapshot.hasData ? snapshot.data.description : null,
            labelText: R.strings.confirmPassword,
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
