import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import '../../helpers/i18n/i18n.dart';
import '../../../ui/components/components.dart';

class SignUpPage extends StatelessWidget with KeyboardManager, LoadingManager, MainErrorManager, NavigateManager {
  final SignUpPresenter presenter;

  const SignUpPage({this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleMainError(stream: presenter.mainErrorStream, context: context);
          handleNavigate(stream: presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.addAccount,
                  ),
                  Provider.value(
                    value: presenter,
                    child: Form(
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
                            onPressed: presenter.goToLogin,
                            icon: Icon(Icons.exit_to_app),
                            label: Text(R.strings.goToLogin),
                          )
                        ],
                      ),
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
