import 'package:flutter/material.dart';

import './splash.dart';
import '../../mixins/mixins.dart';

class SplashPage extends StatelessWidget with NavigateManager {
  final SplashPresenter presenter;

  const SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkCurrentAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Builder(builder: (ctx) {
        handleNavigate(stream: presenter.navigateToStream);
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
