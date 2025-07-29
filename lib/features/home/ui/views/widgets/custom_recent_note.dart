import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomRecentNote extends StatelessWidget {
  final bool? isSelected;
  final String? title;
  final String? description;
  const CustomRecentNote({super.key, this.isSelected = false, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: 168.w,
        height: 198.h,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ==  false ? Colors.white : AppColor.primaryColor,
            width: 1.5.w,
          ),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "Getting Started",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Divider(
              height: 16.h,
            ),
            Text(
              description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}