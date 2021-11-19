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
          widget.presenter.isLoadinController.listen(
            (isLoading) {
              if (isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );

          widget.presenter.mainErrorController.listen((error) {
            if (error != null) {
              showErrorMessage(context: context, error: error);
            }
          });

          return SingleChildScrollView(
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
                            child: StreamBuilder<String>(
                              stream: widget.presenter.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: widget.presenter.validatePassword,
                                  decoration: InputDecoration(
                                    errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                                    labelText: 'Senha',
                                    icon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  obscureText: true,
                                );
                              },
                            ),
                          ),
                          StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidController,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                onPressed: snapshot.data == true ? widget.presenter.auth : null,
                                child: Text('ENTRAR'),
                              );
                            },
                          ),
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
          );
        },
      ),
    );
  }
}
