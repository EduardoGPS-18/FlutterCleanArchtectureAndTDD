import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login.dart';
import '../../../helpers/i18n/i18n.dart';
import '../../../helpers/errors/errors.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            errorText: snapshot.data?.description,
            labelText: R.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}
