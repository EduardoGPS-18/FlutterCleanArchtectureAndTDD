import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            labelText: 'Email',
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
