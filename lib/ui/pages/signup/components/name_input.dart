import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/i18n.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<Object>(
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateName,
          decoration: InputDecoration(
            labelText: R.strings.name,
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
