import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';
import 'package:note_app/core/widgets/custom_button.dart';
import 'package:note_app/features/home/ui/views/widgets/rich_text_editor.dart';
import 'package:note_app/features/home/ui/views/widgets/weight_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_loading_app.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../onboarding/ui/cubit/onboarding_cubit.dart';
import '../../../onboarding/ui/views/widgets/custom_text_button.dart';
import '../cubit/note_cubit.dart';
import '../../data/models/notes_model.dart';

class EditNote extends StatelessWidget {
  final NotesModel note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _contentFocusNode = FocusNode();

  EditNote({super.key, required this.note}) {
    // Initialize controllers with existing note data
    _titleController.text = note.title ?? '';
    _contentController.text = note.content ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteCubit, NoteState>(
      listener: (context, state) {
        if (state is AddNoteLoading) {
          showLoadingApp(context);
        } else if (state is TitleEdit) {
          _titleController.text = state.message;
          _titleController.selection = TextSelection.fromPosition(
            TextPosition(offset: _titleController.text.length),
          );
        } else if (state is NoteEditSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note updated successfully')),
          );
        } else if (state is NoteAddFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is NoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () async {
                        final noteCubit = context.read<NoteCubit>();
                        // Check if either title or content is not empty
                        if (_titleController.text.trim().isNotEmpty ||
                            _contentController.text.trim().isNotEmpty) {
                            noteCubit.editNote(note.noteId.toString());
                        } else {
                          // Show a message if both fields are empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please enter a title and content before saving'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.sp,
                      color: AppColor.textGray,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "Page Title",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26.sp,
                        color: AppColor.textGray,
                      ),
                    ),
                    onChanged: (newText) =>
                        context.read<NoteCubit>().updateTitle(newText),
                    onSubmitted: (_) => _contentFocusNode.requestFocus(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<NoteCubit, NoteState>(
                      buildWhen: (previous, current) =>
                      current is TextStyleState,
                      builder: (context, state) {
                        final cubit = context.read<NoteCubit>();
                        return RichTextEditor(
                          focusNode: _contentFocusNode,
                          styles: cubit.textStyle,
                          controller: _contentController,
                          defaultWeight: cubit.defaultWeight,
                          onChanged: (value) {
                            cubit.updateContent(value);
                            _contentController.text = value;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            });
                          },
                          onTap: () {
                            _showFontWeightBottomSheet(context);
                          },
                          onSelectionChanged: (selection) {
                            cubit.updateTextSelection(
                              selection.start as TextSelection,
                              selection.end,
                            );
                          },
                          onTextChanged: () {},
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.text_format),
          onPressed: () => _showFontWeightBottomSheet(context),
        ),
      ),
    );
  }

  Widget _buildWeightButton(
      BuildContext context, String label, FontWeight weight) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
      onPressed: () {
        context.read<NoteCubit>().selectWeight(weight);
        Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.text_fields,
            size: 24.sp,
            color: Colors.black,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showFontWeightBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Column(
            children: [
              Text(
                'Text Style',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeightButton(context, 'Light', FontWeight.w300),
                  _buildWeightButton(context, 'Regular', FontWeight.normal),
                  _buildWeightButton(context, 'SemiBold', FontWeight.w600),
                  _buildWeightButton(context, 'Bold', FontWeight.bold),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void dispose() {
    _contentFocusNode.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
  }
}