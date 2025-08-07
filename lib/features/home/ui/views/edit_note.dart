import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/notes_model.dart';
import '../cubit/note_cubit.dart';

class EditNoteScreen extends StatelessWidget {
  final NotesModel note;
  const EditNoteScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is NoteEditSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Note Edited Successfully!')));

            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<NoteCubit>();
          cubit.titleController.text = note.title ?? '';
          cubit.contentController.text = note.content ?? '';
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        hintText: 'Title',
                        controller: cubit.titleController,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.title),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Content',
                        controller: cubit.contentController,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Content';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.notes),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'saveNote',
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          context.read<NoteCubit>().editNote(note.noteId.toString());
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}