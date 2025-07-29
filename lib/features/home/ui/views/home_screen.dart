
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_grid_view.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_header.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_recent_note.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/repos/note_repo_imp.dart';
import '../cubit/note_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      NoteCubit(NoteRepoImpl())
        ..getAllNotes(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(22.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeader(),
                16.verticalSpace,
                CustomTextFormField(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: AppColor.textGray,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                22.verticalSpace,
                CustomGridView(),
                20.verticalSpace,
                Text(
                  "Recent Notes",
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRecentNote(isSelected: true),
                    12.horizontalSpace,
                    CustomRecentNote(
                      title: "UX Design",
                      description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam cum ligula justo. Nisi, consectetur elementum.",
                    ),
                  ],
                ),
                12.verticalSpace,
                BlocBuilder<NoteCubit, NoteState>(
                  builder: (context, state) {


                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CustomCardNote(),
                      separatorBuilder: (context, index) => 12.verticalSpace,
                      itemCount: 8,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}