import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../cubit/note_cubit.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM, y').format(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${context.read<NoteCubit>().username} - ",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              "Notes",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton.outlined(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(1)),
            side: MaterialStateProperty.all(
              BorderSide(color: AppColor.primaryColor, width: 1.5.w),
            ),
          ),
          onPressed: () {
            context.pushReplacementNamed(Routes.loginScreen);
          },
          icon: Icon(
            Icons.more_horiz_outlined,
            color: AppColor.primaryColor,
            size: 25.sp,
          ),
        ),
      ],
    );
  }
}