import 'package:flutter/material.dart';

import './splash.dart';
import '../../mixins/mixins.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({@required this.presenter});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigateManager {
  @override
  void initState() {
    handleNavigate(stream: widget.presenter.navigateToStream, clear: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.presenter.checkCurrentAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
