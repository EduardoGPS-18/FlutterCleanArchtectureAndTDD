import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 32,
                      ),
                      child: StreamBuilder<String>(
                        stream: presenter.passwordErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: presenter.validatePassword,
                            decoration: InputDecoration(
                              errorText: snapshot.data,
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
                    RaisedButton(
                      onPressed: null,
                      child: Text('ENTRAR'),
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
      ),
    );
  }
}
