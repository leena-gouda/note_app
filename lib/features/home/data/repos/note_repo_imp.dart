
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

}