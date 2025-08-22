part of 'hidden_cubit.dart';

@immutable
sealed class HiddenState {}

final class NoteInitial extends HiddenState {}

final class HiddenLoading extends HiddenState {}
final class HiddenError extends HiddenState {
  final String message;

  HiddenError(this.message);
}

final class HiddenNotesLoaded extends HiddenState {
  final List<NotesModel> hiddenNotes;
  HiddenNotesLoaded(this.hiddenNotes);
}