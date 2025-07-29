import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.height = 55,
    this.borderRadius = 4.0,
    this.textStyle,
    this.iconData,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
         TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        ),
      )
    );
  }
}