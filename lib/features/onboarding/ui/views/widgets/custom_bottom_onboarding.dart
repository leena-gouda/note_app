
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../data/repos/onboarding_data.dart';
import '../../cubit/onboarding_cubit.dart';
import 'custom_text_button.dart';

class CustomBottomOnboarding extends StatelessWidget {
  const CustomBottomOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        final controller = context.read<OnboardingCubit>();
        final isLastPage = state == (onboardingPages.length - 1);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SizedBox(
              width: double.infinity,
              height: 56.h,
              child:CustomButton(
                text:
                state == (onboardingPages.length - 1)
                    ? 'Get Started'
                    : 'Next',
                onPressed: () {
                  if (isLastPage) {
                    context.pushNamedAndRemoveUntil(Routes.loginScreen);
                  } else {
                    controller.nextPage();
                  }
                },
                backgroundColor: AppColor.primaryColor,
                textStyle: TextStyle(fontWeight: FontWeight.w700,fontSize: 18.sp),
                borderRadius: 14.r,
              )
          ),
        );
      },
    );
  }
}