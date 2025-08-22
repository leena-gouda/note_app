
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:note_app/features/hidden/data/repos/hidden_repo.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';

class HiddenRepoImpl implements HiddenRepo {
  final dio = DioClient();

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

}