import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './splash.dart';

class SplashPage extends StatelessWidget {
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
        presenter.navigateStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
