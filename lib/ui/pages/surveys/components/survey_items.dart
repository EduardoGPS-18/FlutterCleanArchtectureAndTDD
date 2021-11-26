import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'components.dart';

import '../../pages.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyItems(this.viewModels);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        items: viewModels.map((viewModel) => SurveyItem(viewModel)).toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
      ),
    );
  }
}
