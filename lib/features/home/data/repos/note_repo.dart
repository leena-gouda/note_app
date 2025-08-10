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

  Future<void> restoreNote(String noteId);

  Future<void> emptyTrash();

  Future<void> permanentDelete(String noteId);

  Future<String> editeNote(String noteId ,String title, String content);

  Future<void> updateFavorite({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  });

  Future<void> updateHidden({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  });

}