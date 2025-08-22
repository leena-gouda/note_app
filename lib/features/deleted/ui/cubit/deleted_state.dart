part of 'deleted_cubit.dart';

@immutable
sealed class DeletedState {}

final class NoteInitial extends DeletedState {}
final class DeletedLoading extends DeletedState {}

final class NoteDeleteSuccess extends DeletedState {
  final String message;

  NoteDeleteSuccess(this.message);
}

final class DeletedError extends DeletedState {
  final String message;

  DeletedError(this.message);
}

final class RestoreNoteSuccess extends DeletedState {
  final String message;
  final List<NotesModel> notes;

  RestoreNoteSuccess(this.message, this.notes);
}

final class RestoreNoteError extends DeletedState {
  final String message;

  RestoreNoteError(this.message);
}

final class EmptyTrashSuccess extends DeletedState {
  final String? message;
  final List<NotesModel> notes;

  EmptyTrashSuccess(this.message, this.notes);
}
final class EmptyTrashError extends DeletedState {
  final String message;

  EmptyTrashError(this.message);
}


final class DeletedNotesLoaded extends DeletedState {
  final List<NotesModel> deletedNotes;
  DeletedNotesLoaded(this.deletedNotes);
}
final class NotePermanentDeleteSuccess extends DeletedState {
  final String message;
  final List<NotesModel> notes;
  NotePermanentDeleteSuccess(this.message, this.notes);
}

final class NotePermanentDeleteError extends DeletedState {
  final String message;

  NotePermanentDeleteError(this.message);
}