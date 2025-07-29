import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';

class CustomLoginWithGoogle extends StatelessWidget {
  final String imagePath;
  final void Function()? onTap;

  const CustomLoginWithGoogle({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 27.r,
        backgroundColor: AppColor.primaryColor,
        child: CircleAvatar(
          radius: 25.r,
          backgroundColor: AppColor.secondaryColor,
          child: SvgPicture.asset(imagePath, width: 26.w, height: 26.h),
        ),
      ),
    );
  }
}