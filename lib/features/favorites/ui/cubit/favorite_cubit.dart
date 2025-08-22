import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/features/favorites/data/repos/favorite_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/notes_model.dart';
import '../../../home/data/repos/note_repo.dart';
import '../../../home/data/repos/note_repo_imp.dart';
import '../../../home/ui/cubit/note_cubit.dart';

import '../../../add_edit/data/models/text_Style_model.dart';
import '../../../add_edit/data/models/text_style_range_model.dart';



part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final NoteRepo noteRepo;
  final FavoriteRepo favoriteRepo;

  final NoteCubit notecubit = NoteCubit(NoteRepoImpl());

  FavoriteCubit(this.favoriteRepo, this.noteRepo) : super(NoteInitial());

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NotesModel> notesList = [];

  String? userId;
  String? username;
  String? email;


  Future<void> updateFavorite({
    required String noteId,
    required bool isFavorite,
  }) async {
    emit(NoteLoading());
    try {
      await favoriteRepo.updateFavorite(
        noteId: noteId,
        isFavorite: isFavorite,
        isHidden: false,
      );
      if (state is FavoritesLoaded) {
        loadFavorites();
      } else {
        notecubit.getAllNotes();
      }
    } catch (e) {
      emit(NoteError('Failed to update note status'));
    }
  }

  Future<void> loadFavorites() async {
    emit(NoteLoading());
    try {
      final result = await noteRepo.getAllNotes(userId.toString());
      result.fold(
            (error) => emit(NoteError(error)),
            (notes) {
          final favorites = notes.where((n) => n.isFavorite).toList();
          emit(FavoritesLoaded(favorites));
        },
      );
    } catch (e) {
      emit(NoteError('Failed to load favorites'));
    }
  }

}