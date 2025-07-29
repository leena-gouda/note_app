import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/theme/app_colors.dart';

import '../../cubit/onboarding_cubit.dart';
import 'custom_text_button.dart';

class CustomHeaderOnboarding extends StatelessWidget {
  const CustomHeaderOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        var controller = context.read<OnboardingCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: state != 0,
              child: CustomTextButton(
                isBack: true,
                text: 'Back',
                color: AppColor.primaryColor,
                onPressed: () {
                  controller.previousPage();
                },
              ),
            ),
            CustomTextButton(
              text: "Skip",
              color: AppColor.primaryColor,
              onPressed: () {
                context.read<OnboardingCubit>().skip();
              },
            ),
          ],
        );
      },
    );
  }
}