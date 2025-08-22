import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/text_style_range_model.dart';

class RichTextEditor extends StatelessWidget {
  final TextEditingController controller;
  final List<TextStyleRange> styles;
  final FontWeight defaultWeight;
  final FocusNode focusNode;
  final ValueChanged<TextSelection> onSelectionChanged;
  final VoidCallback onTextChanged;

  const RichTextEditor({
    required this.controller,
    required this.styles,
    required this.defaultWeight,
    required this.focusNode,
    required this.onSelectionChanged,
    required this.onTextChanged, required Null Function(dynamic value) onChanged, required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration.collapsed(
        hintText: "start writing...",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: AppColor.textGray,
        ),
      ),
      style: _getMergedTextStyle(),
      onChanged: (_) => onTextChanged?.call(),

    );
  }
  void _handleSelectionChange() {
    final selection = controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      onSelectionChanged?.call(selection);
    }
  }

  TextStyle _getMergedTextStyle() {
    return TextStyle(
      fontWeight: defaultWeight,
      fontSize: 16.sp,
    );
  }
  void dispose() {
    controller.removeListener(_handleSelectionChange);
  }
}