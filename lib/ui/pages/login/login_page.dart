import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import './components/components.dart';
import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with KeyboardManager, LoadingManager, NavigateManager, MainErrorManager {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Builder(
        builder: (context) {
          handleNavigate(stream: widget.presenter.navigateToStream, clear: true);
          handleLoading(context: context, stream: widget.presenter.isLoadingStream);
          handleMainError(stream: widget.presenter.mainErrorStream, context: context);

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
                    child: ListenableProvider.value(
                      value: widget.presenter,
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
                            ElevatedButton.icon(
                              onPressed: widget.presenter.goToSignUp,
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
