part of 'note_cubit.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}
final class AddNoteLoading extends NoteState {}

final class NoteSuccess extends NoteState {
  final List<NotesModel> notes;
  final bool isSearchResult;

  NoteSuccess(this.notes,{this.isSearchResult = false});
}

final class NoteError extends NoteState {
  final String message;

  NoteError(this.message);
}


final class NoteAddedSuccess extends NoteState {
  final String message;

  NoteAddedSuccess(this.message);
}

final class NoteDeleteSuccess extends NoteState {
  final String message;

  NoteDeleteSuccess(this.message);
}

final class NoteEditSuccess extends NoteState {
  final String message;

  NoteEditSuccess(this.message);
}

final class TitleEdit extends NoteState {
  final String message;

  TitleEdit(this.message);
}

final class ContentUpdate extends NoteState{
  final String message;

  ContentUpdate(this.message);
}
final class TextStyleState extends NoteState{
  final FontWeight selectedWeight;
  final bool showOptions;

  TextStyleState({required this.showOptions, required this.selectedWeight});

  factory TextStyleState.inactive() => TextStyleState(
    showOptions: false,
    selectedWeight: FontWeight.normal,
  );

  factory TextStyleState.active({required FontWeight selectedWeight}) => TextStyleState(
    showOptions: true,
    selectedWeight: selectedWeight,
  );
}

final class TextStyleUpdated extends NoteState {
  final List<TextStyleSelection> textStyles;

  TextStyleUpdated(this.textStyles);
}

final class DefaultStyleUpdated extends NoteState {
  final FontWeight defaultWeight;

  DefaultStyleUpdated(this.defaultWeight);
}

final class TextSelectionUpdated extends NoteState {
  final TextSelection? selection;
  TextSelectionUpdated(this.selection);
}

final class TextSelectionCleared extends NoteState {}

final class NoteAddFailed extends NoteState {
  final String message;

  NoteAddFailed(this.message);
}

final class updateNoteStatus extends NoteState {
  final String noteId;
  final bool isFavorite;
  final bool isHidden;

  updateNoteStatus({
    required this.noteId,
    required this.isFavorite,
    required this.isHidden,
  });
}

final class NoteStatusUpdateFailed extends NoteState {
  final String message;
  NoteStatusUpdateFailed(this.message);
}
final class DeletedNotesLoaded extends NoteState {
  final List<NotesModel> deletedNotes;
  DeletedNotesLoaded(this.deletedNotes);
}
final class NotePermanentDeleteSuccess extends NoteState {
  final String message;
  final List<NotesModel> notes;
  NotePermanentDeleteSuccess(this.message, this.notes);
}

final class FavoritesLoaded extends NoteState {
  final List<NotesModel> favorites;
  FavoritesLoaded(this.favorites);
}

final class HiddenNotesLoaded extends NoteState {
  final List<NotesModel> hiddenNotes;
  HiddenNotesLoaded(this.hiddenNotes);
}