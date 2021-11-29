import 'package:flutter/material.dart';

import '../pages.dart';
import 'components/components.dart';

import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveyResultPage extends StatefulWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({
    @required this.presenter,
  });

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> with LoadingManager, SessionManager {
  @override
  void initState() {
    handleLoading(context: context, stream: widget.presenter.isLoadingStream);
    handleSession(stream: widget.presenter.isSessionExpiredStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          widget.presenter.loadData();
          return StreamBuilder<SurveyResultViewModel>(
            stream: widget.presenter.surveyResultStream,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.presenter.loadData,
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
