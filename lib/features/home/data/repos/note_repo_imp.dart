
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/note_req_add_model.dart';
import '../models/notes_model.dart';
import 'note_repo.dart';

class NoteRepoImpl implements NoteRepo {
  final dio = DioClient();

  @override
  Future<NotesModel> getNoteById(String noteId) async {
    final response = await dio.get(
      EndpointConstants.getOnlyNote,
      queryParameters: {'noteId': noteId},
    );
    if (response is Map<String, dynamic>) {
      return NotesModel.fromJson(response as Map<String, dynamic>);
    }
    throw response;
  }

  @override
  Future<String> addNote(NoteReqAddModel note) async {
    final response = await dio.post(EndpointConstants.addNote, queryParameters: note.toJson());
    if (response.data['status'] == 'success') {
      return response.data['message'] ?? 'Note added successfully';
    }
    print(response);
    throw Exception(response.data['message'] ?? 'Failed to add note');
  }


  @override
  Future<Either<String, List<NotesModel>>> getAllNotes(String userId) async {
    final response = await dio.get(
      EndpointConstants.getAllNotes,
      queryParameters: {'users_id': userId, 'is_deleted': false},
    );

    if (response.data['status'] == 'success' && response.data['data'] is List) {
      return right((response.data['data'] as List)
          .map((e) => NotesModel.fromJson(e))
          .toList());
    } else {
      return left(response.data['message'] ?? 'Failed to load notes');
    }
  }
  @override
  Future<String> deleteNote(String noteId) async {
    final response = await dio.post(
      EndpointConstants.deleteNote, data: {'note_id': noteId, 'is_deleted':true, 'deleted_at': DateTime.now().toIso8601String()},
    );

    if (response.data['status'] == 'success') {
      return response.data['message'] ?? 'Note Moved to trash';
    } else {
      throw Exception(response.data['message'] ?? 'Failed to move note to trash');
    }
  }

  @override
  Future<String> editeNote(String noteId, String title, String content) async{
    final response =await dio.post(
      EndpointConstants.editNote,
      data: {
        'note_id': noteId,
        'title': title,
        'content': content,
      },
    );
    if (response.data['status'] == 'success') {
      return response.data['message'] ?? 'Note deleted successfully';
    } else {
      throw response;
    }
  }

  @override
  Future<void> updateHidden({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  }) async {
    try {
      // If using API
      await dio.post(EndpointConstants.isHidden,
          data: {
            'note_id': noteId,
            'is_favorite': isFavorite,
            'is_hidden': isHidden,
          }
      );
    } catch (e) {
      throw Exception('Failed to update note status: $e');
    }
  }

  @override
  Future<void> updateFavorite({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  }) async {
    try {
      // If using API
      await dio.post(EndpointConstants.isFavorite,
          data: {
            'note_id': noteId,
            'is_favorite': isFavorite,
            'is_hidden': isHidden,
          }
      );
    } catch (e) {
      throw Exception('Failed to update note status: $e');
    }
  }

  @override
  Future<void> emptyTrash() async {
    final response = await dio.delete(
      EndpointConstants.emptyTrash,
    );
    if (response.data['status'] == 'success') {
      return response.data['message'] ?? 'trash emptied successfully';
    }
    else {
      throw response;
    }

  }

  @override
  Future<void> restoreNote(String noteId) async {
    final response = await dio.post(EndpointConstants.restoreNote,
        data: {
          'note_id': noteId,
          'is_deleted': false,
          'deleted_at': null,
        }
    );
    if (response.data['status'] == 'success') {
      return response.data['message'] ?? 'Note restored successfully';
    }
    else {
      throw response;
    }
  }

  @override
  Future<void> permanentDelete(String noteId) async {
    final response = await dio.delete(
      '${EndpointConstants.permanentDelete}/$noteId', // e.g., '/notes/permanent/$noteId'
    );

    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Failed to permanently delete note');
    }
  }
}