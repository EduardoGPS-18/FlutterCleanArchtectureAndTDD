import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import '../../helpers/i18n/i18n.dart';
import '../../../ui/components/components.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter presenter;

  const SignUpPage({this.presenter});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with KeyboardManager, LoadingManager, MainErrorManager, NavigateManager {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    handleLoading(context: context, stream: widget.presenter.isLoadingStream);
    handleMainError(stream: widget.presenter.mainErrorStream, scaffoldKey: scaffoldKey);
    handleNavigate(stream: widget.presenter.navigateToStream, clear: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
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
                value: widget.presenter,
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
                        onPressed: widget.presenter.goToLogin,
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
      ),
    );
  }
}
