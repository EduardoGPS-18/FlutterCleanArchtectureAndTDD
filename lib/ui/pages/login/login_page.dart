import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

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
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[700],
                  content: Text(error),
                ),
              );
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
                  child: Form(
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                          stream: widget.presenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: widget.presenter.validateEmail,
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
                        ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
