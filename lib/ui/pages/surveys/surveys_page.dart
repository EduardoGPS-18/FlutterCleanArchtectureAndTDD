import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveysPage extends StatelessWidget with LoadingManager, NavigateManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (ctx) {
          handleLoading(context: context, stream: presenter.isLoadingStream);
          handleSession(stream: presenter.isSessionExpiredStream);
          handleNavigate(stream: presenter.navigateToStream);

          presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider.value(
                  value: presenter,
                  child: SurveyItems(
                    snapshot.data,
                  ),
                );
              }
              return Center();
            },
          );
        },
      ),
    );
  }
}
