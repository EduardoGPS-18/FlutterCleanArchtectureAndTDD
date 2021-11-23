import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/i18n/i18n.dart';
import '../../../helpers/errors/errors.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateName,
          decoration: InputDecoration(
            labelText: R.strings.name,
            errorText: snapshot.hasData ? snapshot.data.description : null,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.name,
        );
      },
    );
  }
}
