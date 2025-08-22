import 'package:note_app/features/add_edit/data/repos/add_edit_repo.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/note_req_add_model.dart';

class AddEditRepoImpl implements AddEditRepo {
  final dio = DioClient();

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

}