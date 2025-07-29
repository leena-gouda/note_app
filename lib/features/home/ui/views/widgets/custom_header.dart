import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});
  String _formatDate(DateTime date) {
    final monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    return "${date.day} ${monthNames[date.month - 1]}, ${date.year}";
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(DateTime.now()),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Notes",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.ellipsis_circle,
            color: AppColor.primaryColor,
            size: 35.sp,
          ),
        ),
      ],
    );
  }
}