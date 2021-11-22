import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login.dart';

import '../../../helpers/errors/errors.dart';
import '../../../../utils/i18n/i18n.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            errorText: snapshot.hasData ? snapshot.data.description : null,
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
