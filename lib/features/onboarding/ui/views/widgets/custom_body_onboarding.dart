import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/repos/onboarding_data.dart';
import '../../cubit/onboarding_cubit.dart';

class CustomBodyOnboarding extends StatelessWidget {
  const CustomBodyOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return PageView.builder(
          controller: cubit.pageController,
          onPageChanged: (i) => cubit.chanePage(i),
          itemCount: onboardingPages.length,
          itemBuilder: (context, index) {
            final page = onboardingPages[index];
            // print('Building page $index with image path: ${page.image}'); // Debug print
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Expanded(
                  //   child: Container(color: Colors.red), // Instead of Image.asset
                  // ),
                  Expanded(

                      child: Image.asset(page.image,fit: BoxFit.contain,)
                  ),
                  //SizedBox(height: 16),
                  32.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      List.generate(
                        onboardingPages.length,
                        (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: index == state ? 100.w : 100.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color:
                            index == state ? AppColor.primaryColor : AppColor.textGray,
                            borderRadius: BorderRadius.circular(4.r),
                            ),
                        ),
                        ),
                      ),
                  ),
                  32.verticalSpace,

                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40.w,right: 40.w),
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 32.sp,
                            height: 1.2.h,
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      16.verticalSpace,
                      Text(
                        page.subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45,
                          height: 1.5.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}