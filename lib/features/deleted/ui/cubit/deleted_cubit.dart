import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/features/deleted/data/repos/deleted_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/notes_model.dart';
import '../../../home/data/repos/note_repo.dart';
import '../../../home/data/repos/note_repo_imp.dart';
import '../../../home/ui/cubit/note_cubit.dart';

import '../../../add_edit/data/models/text_Style_model.dart';
import '../../../add_edit/data/models/text_style_range_model.dart';
import '../../data/repos/deleted_repo_impl.dart';



part 'deleted_state.dart';

class DeletedCubit extends Cubit<DeletedState> {
  final NoteRepo noteRepo;
  final DeletedRepo deletedRepo = DeletedRepoImpl();
  final NoteCubit noteCubit = NoteCubit(NoteRepoImpl());

  DeletedCubit(this.noteRepo) : super(NoteInitial()) ;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NotesModel> notesList = [];




  String? userId;
  String? username;
  String? email;

  void deleteNote(String noteId) async {
    emit(DeletedLoading());
    try {
      final message = await deletedRepo.deleteNote(noteId);
      emit(NoteDeleteSuccess(message)); // Clear the notes list
      noteCubit.getAllNotes(); // Refresh the notes list
    } catch (e) {
      emit(DeletedError(e.toString()));
      print(e);
    }
  }

  Future<void> restoreNote(String noteId) async {
    emit(NoteLoading() as DeletedState);
    try {
      await deletedRepo.restoreNote(noteId);

      final updatedNotes = await noteRepo.getAllNotes(userId.toString());

      emit(RestoreNoteSuccess("",updatedNotes as List<NotesModel> ));

    } catch (e) {
      emit(RestoreNoteError('Failed to restore note'));
    }
  }

  Future<void> emptyTrash() async {
    emit(NoteLoading() as DeletedState);
    try {
      await deletedRepo.emptyTrash();
      final updatedNotes = await noteRepo.getAllNotes(userId.toString());
      emit(EmptyTrashSuccess(" ",updatedNotes as List<NotesModel>));
    } catch (e) {
      emit(EmptyTrashError('Failed to empty trash'));
    }
  }

  Future<void> permanentDelete(String noteId) async {
    emit(NoteLoading() as DeletedState);
    try {
      await deletedRepo.permanentDelete(noteId);
      final notes = await noteRepo.getAllNotes(userId!);
      emit(NotePermanentDeleteSuccess('Note permanently deleted', notes as List<NotesModel>));
    } catch (e) {
      emit(NotePermanentDeleteError('Failed to permanently delete note: ${e.toString()}'));
    }
  }

  Future<void> loadDeletedNotes() async {
    emit(NoteLoading() as DeletedState);
    try {
      final Either<String, List<NotesModel>> result = await noteRepo.getAllNotes(userId.toString());

      result.fold(
            (error) => emit(NoteError(error) as DeletedState),
            (notes) {
          final deletedNotes = notes.where((n) => n.isDeleted).toList();
          emit(DeletedNotesLoaded(deletedNotes));
        },
      );
    } catch (e) {
      emit(NoteError('Failed to load deleted notes: ${e.toString()}') as DeletedState);
    }
  }
}