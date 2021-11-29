import 'package:flutter/material.dart';

import '../pages.dart';
import 'components/components.dart';

import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveyResultPage extends StatelessWidget with LoadingManager, SessionManager {
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
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleSession(stream: presenter.isSessionExpiredStream);

          presenter.loadData();
          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
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
