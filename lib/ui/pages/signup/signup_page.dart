import 'package:flutter/material.dart';

import 'components/components.dart';

import '../../../ui/components/components.dart';
import '../../helpers/i18n/i18n.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          void _hideKeyboard() {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.addAccount,
                  ),
                  Form(
                    child: Column(
                      children: [
                        NameInput(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: EmailInput(),
                        ),
                        PasswordInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                          child: PasswordConfirmationInput(),
                        ),
                        SignUpButton(),
                        FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.exit_to_app),
                          label: Text(R.strings.addAccount),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
