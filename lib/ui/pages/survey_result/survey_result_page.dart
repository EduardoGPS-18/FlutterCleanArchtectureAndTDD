import 'package:flutter/material.dart';

import '../pages.dart';
import 'components/components.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({
    @required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          presenter.isLoading.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter.loadData();
          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveysData,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyResult(snapshot.data);
              }
              return Center();
            },
          );
        },
      ),
    );
  }
}
