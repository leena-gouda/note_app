
import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/note_req_add_model.dart';
import '../models/notes_model.dart';
import 'note_repo.dart';

class NoteRepoImpl implements NoteRepo {
  final dio = DioClient();

  @override
  NotesModel getNoteById(String noteId) {
    final response = dio.get(
      EndpointConstants.getOnlyNote,
      queryParameters: {'noteId': noteId},
    );
    if (response is Map<String, dynamic>) {
      return NotesModel.fromJson(response as Map<String, dynamic>);
    }
    throw response;
  }

  @override
  addNote(NoteRustAddModel note) {
    final response = dio.post(EndpointConstants.addNote, data: note);
    print(response);
  }

  @override
  Future<List<NotesModel>> getAllNotes(String userId) async {
    final response = await dio.get(
      EndpointConstants.getAllNotes,
      queryParameters: {'users_id': userId},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load notes');
    }
    print(response.data); // لمراجعة الشكل
    print(response.data['data'].runtimeType); // هل فعلاً List؟
    print(response.data['data'][0].runtimeType); // هل فعلاً Map؟

    if (response.data['status'] == 'success' && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((e) => NotesModel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }
}