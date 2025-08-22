import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/note_req_add_model.dart';
import '../../data/models/notes_model.dart';
import '../../../add_edit/data/models/text_Style_model.dart';
import '../../../add_edit/data/models/text_style_range_model.dart';
import '../../data/repos/note_repo.dart';



part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepo noteRepo;

  NoteCubit(this.noteRepo) : super(NoteInitial()) {
    getUserData();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NotesModel> notesList = [];




  String? userId;
  String? username;
  String? email;

  void searchNotes(String query) {
    if (query.isEmpty) {
      emit(NoteSuccess(notesList));
      return;
    }

    emit(NoteLoading());
    try {
      final results = notesList.where((note) =>
      note.title!.toLowerCase().contains(query.toLowerCase()) ||
          note.content!.toLowerCase().contains(query.toLowerCase())
      ).toList();
      emit(NoteSuccess(results, isSearchResult: true));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  // Add this method
  void clearSearch() {
    emit(NoteSuccess(notesList));
  }

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    print("userId : $userId");
    email = prefs.getString("email") ?? "";
    username = prefs.getString("username") ?? "";

    getAllNotes();
  }

  void getAllNotes() async {
    if (userId == null) {
      emit(NoteError("User ID is not available"));
      return;
    }
    emit(NoteLoading());
      final notes = await noteRepo.getAllNotes(userId.toString());

      notes.fold(
            (l) {
          emit(NoteError(l.toString()));
        },
            (notes) {
          notesList = notes;
          emit(NoteSuccess(notes));
        },
      );
  }
}