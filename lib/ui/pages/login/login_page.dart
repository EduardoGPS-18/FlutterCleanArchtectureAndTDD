import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import './components/components.dart';
import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';
import '../../helpers/errors/errors.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager, NavigateManager, MainErrorManager {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleNavigate(stream: presenter.navigateToStream, clear: true);
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleMainError(stream: presenter.mainErrorStream, context: context);
          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.login,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider.value(
                      value: presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 32,
                              ),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            FlatButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: Icon(Icons.person),
                              label: Text(R.strings.goToSignUp),
                            )
                          ],
                        ),
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
