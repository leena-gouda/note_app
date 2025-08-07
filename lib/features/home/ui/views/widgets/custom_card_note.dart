import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/home/data/repos/note_repo.dart';
import 'package:note_app/features/home/data/repos/note_repo_imp.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/notes_model.dart';
import '../../cubit/note_cubit.dart';

class CustomCardNote extends StatelessWidget {
  final NotesModel  note;
  const CustomCardNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final createdAt = note.createdAt ?? "";
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(CupertinoIcons.trash, color: Colors.white, size: 35.sp),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async{
        return await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.only(top: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              title: Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    "Delete Note",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
              content: const Text("Are you sure you want to delete this note?",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context,false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: (){
                    context.read<NoteCubit>().deleteNote(note.noteId.toString());
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Delete")
                ),

              ],
            )
        );
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        shadowColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.note_alt_outlined,color: Colors.teal,),
                  Text(createdAt.split(" ").first,style: TextStyle(fontSize: 12.sp, color: Colors.black),),
                ],
              ),
              SizedBox(height: 12.h),
              Text(note.title ?? "No Title",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              Divider(thickness: 1, height: 16.h),
              Text(
                note.content ?? "No content available for this note.",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}