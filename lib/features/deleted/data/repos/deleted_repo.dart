
abstract class DeletedRepo {


  Future<String> deleteNote(String noteId);

  Future<void> restoreNote(String noteId);

  Future<void> emptyTrash();

  Future<void> permanentDelete(String noteId);


}