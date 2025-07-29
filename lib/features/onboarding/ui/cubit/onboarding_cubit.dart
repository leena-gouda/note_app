import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../data/repos/onboarding_data.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  final PageController pageController = PageController();

  void chanePage(int index) {
    emit(index);
  }


  void nextPage() {
    // 0 1 2
    // 1 2 3
    if (state < (onboardingPages.length - 1)) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // emit(state + 1);
    }
  }

  void previousPage() {
    // 1 2 3
    // 0 1 2
    if (state > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
    }
  }

  void skip() {
    // Skip to the last page
    pageController.animateToPage(
      (onboardingPages.length - 1),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}