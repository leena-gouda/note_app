part of 'note_cubit.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}


final class NoteSuccess extends NoteState {
  final List<NotesModel> notes;
  final bool isSearchResult;

  NoteSuccess(this.notes,{this.isSearchResult = false});
}

final class NoteError extends NoteState {
  final String message;

  NoteError(this.message);
}


