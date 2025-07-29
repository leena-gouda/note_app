
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/onboarding/ui/views/widgets/custom_body_onboarding.dart';
import 'package:note_app/features/onboarding/ui/views/widgets/custom_bottom_onboarding.dart';
import 'package:note_app/features/onboarding/ui/views/widgets/custom_header_onboarding.dart';

import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building OnboardingScreen'); // Debug print

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeaderOnboarding(),
              Expanded(child: CustomBodyOnboarding()),
              24.verticalSpace,
              const CustomBottomOnboarding(),
              //SizedBox(height: 30),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}