import '../../../home/data/models/note_req_add_model.dart';

abstract class AddEditRepo{
  Future<String> addNote(NoteReqAddModel note);
  Future<String> editeNote(String noteId ,String title, String content);

}