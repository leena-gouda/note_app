part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class NoteInitial extends FavoriteState {}

final class NoteLoading extends FavoriteState {}
final class NoteError extends FavoriteState {
  final String message;

  NoteError(this.message);
}

final class FavoritesLoaded extends FavoriteState {
  final List<NotesModel> favorites;
  FavoritesLoaded(this.favorites);
}


