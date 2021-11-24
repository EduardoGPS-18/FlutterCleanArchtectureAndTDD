import 'package:app_curso_manguinho/ui/components/components.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'surveys_presenter.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (ctx) {
          presenter.isLoading.listen((isLoading) {
            if (isLoading == true) {
              showLoading(ctx);
            } else {
              hideLoading(ctx);
            }
          });
          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error),
                    RaisedButton(
                      onPressed: null,
                      child: Text(R.strings.reload),
                    ),
                  ],
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    items: snapshot.data.map((viewModel) => SurveyItem(viewModel)).toList(),
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
