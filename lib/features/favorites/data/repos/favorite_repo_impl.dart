
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';
import 'favorite_repo.dart';


class FavoriteRepoImpl implements FavoriteRepo {
  final dio = DioClient();

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