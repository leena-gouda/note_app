
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/add_edit_cubit.dart';
import '../../../../home/ui/cubit/note_cubit.dart';

class WeightButton extends StatelessWidget {
  final String label;
  final FontWeight weight;

  const WeightButton({required this.label, required this.weight});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
      ),
      onPressed: () => context.read<AddEditCubit>().selectWeight(weight),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: weight,
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
