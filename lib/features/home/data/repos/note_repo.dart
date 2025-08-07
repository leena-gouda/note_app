import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../models/note_req_add_model.dart';
import '../models/notes_model.dart';

abstract class NoteRepo {
  Future<Either<String, List<NotesModel>>> getAllNotes(String userId);

  //Future<List<NotesModel>> getAllNotes(String userId);

  Future<NotesModel> getNoteById(String noteId);

  Future<String> addNote(NoteReqAddModel note);

  Future<String> deleteNote(String noteId);

  Future<String> editeNote(String noteId ,String title, String content);
}