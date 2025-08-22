part of 'add_edit_cubit.dart';

sealed class AddEditState {}

final class AddEditInitial extends AddEditState {}
final class AddNoteLoading extends AddEditState {}
final class NoteAddEditError extends AddEditState {
  final String message;

  NoteAddEditError(this.message);
}

final class NoteAddedSuccess extends AddEditState {
  final String message;

  NoteAddedSuccess(this.message);
}


final class NoteEditSuccess extends AddEditState {
  final String message;

  NoteEditSuccess(this.message);
}

final class TitleEdit extends AddEditState {
  final String message;

  TitleEdit(this.message);
}

final class ContentUpdate extends AddEditState{
  final String message;

  ContentUpdate(this.message);
}
final class TextStyleState extends AddEditState{
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

final class TextStyleUpdated extends AddEditState {
  final List<TextStyleSelection> textStyles;

  TextStyleUpdated(this.textStyles);
}

final class DefaultStyleUpdated extends AddEditState {
  final FontWeight defaultWeight;

  DefaultStyleUpdated(this.defaultWeight);
}

final class TextSelectionUpdated extends AddEditState {
  final TextSelection? selection;
  TextSelectionUpdated(this.selection);
}

final class TextSelectionCleared extends AddEditState {}

final class NoteAddFailed extends AddEditState {
  final String message;

  NoteAddFailed(this.message);
}

final class updateNoteStatus extends AddEditState {
  final String noteId;
  final bool isFavorite;
  final bool isHidden;

  updateNoteStatus({
    required this.noteId,
    required this.isFavorite,
    required this.isHidden,
  });
}

final class NoteStatusUpdateFailed extends AddEditState {
  final String message;
  NoteStatusUpdateFailed(this.message);
}