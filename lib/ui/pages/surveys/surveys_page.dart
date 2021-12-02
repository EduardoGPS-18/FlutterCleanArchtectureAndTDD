import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage({required this.presenter});

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigateManager, SessionManager, RouteAware {
  @override
  void didPopNext() {
    widget.presenter.loadData();
    super.didPopNext();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    handleLoading(context: context, stream: widget.presenter.isLoadingStream);
    handleSession(stream: widget.presenter.isSessionExpiredStream);
    handleNavigate(stream: widget.presenter.navigateToStream);
    widget.presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context) as PageRoute);
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SurveyViewModel>>(
        stream: widget.presenter.surveysDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ReloadScreen(
              error: "${snapshot.error}",
              reload: widget.presenter.loadData,
            );
          }
          if (snapshot.hasData) {
            return ListenableProvider.value(
              value: widget.presenter,
              child: SurveyItems(
                snapshot.data!,
              ),
            );
          }
          return Center();
        },
      ),
    );
  }
}
