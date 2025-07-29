import 'package:dio/dio.dart';

import '../models/note_req_add_model.dart';
import '../models/notes_model.dart';

abstract class NoteRepo {
  Future<List<NotesModel>> getAllNotes(String userId);

  NotesModel getNoteById(String noteId);

  addNote(NoteRustAddModel note);
}