import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../pages.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveysPage extends StatelessWidget {
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
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(ctx);
            } else {
              hideLoading(ctx);
            }
          });
          presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            }
          });
          presenter.navigateToStream.listen((page) {
            if (page != null && page.isNotEmpty == true) {
              Get.toNamed(page);
            }
          });
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
