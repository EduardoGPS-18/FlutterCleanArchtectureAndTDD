import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );

          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context: context, error: error);
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: 'Login',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider.value(
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
                            FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.person),
                              label: Text('Criar Conta'),
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
