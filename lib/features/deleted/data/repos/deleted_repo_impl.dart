
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:note_app/features/deleted/data/repos/deleted_repo.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';

class DeletedRepoImpl implements DeletedRepo {
  final dio = DioClient();


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