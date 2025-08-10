import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/note_req_add_model.dart';
import '../../data/models/notes_model.dart';
import '../../data/models/text_Style_model.dart';
import '../../data/models/text_style_range_model.dart';
import '../../data/repos/note_repo.dart';



part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepo noteRepo;

  NoteCubit(this.noteRepo) : super(NoteInitial()) {
    getUserData();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NotesModel> notesList = [];

  List<TextStyleRange> textStyle = [];
  TextSelection? _currentSelection;

  TextSelection? _textSelection;
  List<TextStyleSelection> textStyles = [];
  FontWeight defaultWeight = FontWeight.normal;


  String? userId;
  String? username;
  String? email;

  // void searchNotes(String query) {
  //   if (query.isEmpty) {
  //     emit(NoteSuccess(notesList)); // Show all notes if query is empty
  //     return;
  //   }
  //
  //   final filteredNotes = notesList.where((note) {
  //     return note.title!.toLowerCase().contains(query.toLowerCase()) ||
  //         note.content!.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  //
  //   emit(NoteSuccess(filteredNotes));
  // }

  void searchNotes(String query) {
    if (query.isEmpty) {
      emit(NoteSuccess(notesList));
      return;
    }

    emit(NoteLoading());
    try {
      final results = notesList.where((note) =>
      note.title!.toLowerCase().contains(query.toLowerCase()) ||
          note.content!.toLowerCase().contains(query.toLowerCase())
      ).toList();
      emit(NoteSuccess(results, isSearchResult: true));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  // Add this method
  void clearSearch() {
    emit(NoteSuccess(notesList));
  }

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    print("userId : $userId");
    email = prefs.getString("email") ?? "";
    username = prefs.getString("username") ?? "";

    getAllNotes();
  }

  void getAllNotes() async {
    if (userId == null) {
      emit(NoteError("User ID is not available"));
      return;
    }
    emit(NoteLoading());
      final notes = await noteRepo.getAllNotes(userId.toString());

      notes.fold(
            (l) {
          emit(NoteError(l.toString()));
        },
            (notes) {
          notesList = notes;
          emit(NoteSuccess(notes));
        },
      );
  }

  Future<void> addNote({required String title, required String content}) async {
    if (title.isEmpty || content.isEmpty) {
      emit(NoteAddFailed("Validation failed - Title: $title, Content: $content"));
      return;
    }
      if (userId == null) {
        emit(NoteError("User ID is not available"));
        return;
      }
      emit(AddNoteLoading());
      try {
        final message = await noteRepo.addNote(
          NoteReqAddModel(
            title: title,
            content: content,
            userId: userId.toString(),
          ),
        );

        emit(NoteAddedSuccess(message));
         getAllNotes();
        
      } catch (e) {
        emit(NoteError(e.toString()));
        print(e);
      }


  }

  void deleteNote(String noteId) async {
    emit(NoteLoading());
    try {
      final message = await noteRepo.deleteNote(noteId);
      emit(NoteDeleteSuccess(message)); // Clear the notes list
      getAllNotes(); // Refresh the notes list
    } catch (e) {
      emit(NoteError(e.toString()));
      print(e);
    }
  }

  Future<void> restoreNote(String noteId) async {
    emit(NoteLoading());
    try {
      await noteRepo.restoreNote(noteId);

      final updatedNotes = await noteRepo.getAllNotes(userId.toString());

      emit(NoteSuccess(updatedNotes as List<NotesModel>));

    } catch (e) {
      emit(NoteError('Failed to restore note'));
    }
  }

  Future<void> emptyTrash() async {
    emit(NoteLoading());
    try {
      await noteRepo.emptyTrash();
      final updatedNotes = await noteRepo.getAllNotes(userId.toString());
      emit(NoteSuccess(updatedNotes as List<NotesModel>));
    } catch (e) {
      emit(NoteError('Failed to empty trash'));
    }
  }

  Future<void> permanentDelete(String noteId) async {
    emit(NoteLoading());
    try {
      await noteRepo.permanentDelete(noteId);
      final notes = await noteRepo.getAllNotes(userId!);
      emit(NotePermanentDeleteSuccess('Note permanently deleted', notes as List<NotesModel>));
    } catch (e) {
      emit(NoteError('Failed to permanently delete note: ${e.toString()}'));
    }
  }

  Future<void> loadDeletedNotes() async {
    emit(NoteLoading());
    try {
      final Either<String, List<NotesModel>> result = await noteRepo.getAllNotes(userId.toString());

      result.fold(
            (error) => emit(NoteError(error)),
            (notes) {
          final deletedNotes = notes.where((n) => n.isDeleted).toList();
          emit(DeletedNotesLoaded(deletedNotes));
        },
      );
    } catch (e) {
      emit(NoteError('Failed to load deleted notes: ${e.toString()}'));
    }
  }

  void editNote(String noteId) async {
    emit(NoteLoading());
    try {
      final message = await noteRepo.editeNote(noteId, titleController.text, contentController.text);
      emit(NoteEditSuccess(message)); // Clear the notes list
      getAllNotes(); // Refresh the notes list
      titleController.clear();
      contentController.clear();
    } catch (e) {
      emit(NoteError(e.toString()));
      print(e);
    }
  }

  void updateTitle(String newTitle) {
    emit(TitleEdit(newTitle));
  }

  void updateContent(String Content) {
    textChanged(Content);
    emit(ContentUpdate(Content));
  }

  // void updateTextSelection(int start, int end) {
  //   _textSelection = TextSelection(
  //     baseOffset: start,
  //     extentOffset: end,
  //   );
  // }

  void updateTextSelection(TextSelection selection, int end) {
    _currentSelection = selection;
  }

  void clearTextSelection() {
    _textSelection = null;
  }

  void textChanged(String text) {
    debugPrint('Text changed: $text');
    if (text.isNotEmpty) {
      debugPrint('Showing style options');
      final currentWeight = state is TextStyleState
          ? (state as TextStyleState).selectedWeight
          : FontWeight.normal;
      emit(TextStyleState.active(selectedWeight: currentWeight));
    } else {
      debugPrint('Hiding style options');
      emit(TextStyleState.inactive());
    }
  }

  void selectWeight(FontWeight weight) {
    if (_currentSelection != null &&
        _currentSelection!.isValid &&
        !_currentSelection!.isCollapsed) {
      textStyles.add(TextStyleRange(
        start: _currentSelection!.start,
        end: _currentSelection!.end,
        weight: weight,
      ) as TextStyleSelection);
      emit(ContentUpdate("updated"));
    } else {
      defaultWeight = weight;
      emit(DefaultStyleUpdated(defaultWeight));
    }
  }

  Future<void> updateHidden({
    required String noteId,
    required bool isHidden,
  }) async {
    emit(NoteLoading());
    try {
      await noteRepo.updateHidden(
        noteId: noteId,
        isFavorite: false,
        isHidden: isHidden,
      );
      if (state is FavoritesLoaded) {
        loadFavorites();
      } else if (state is HiddenNotesLoaded) {
        loadHiddenNotes();
      } else {
        getAllNotes();
      }
    } catch (e) {
      emit(NoteError('Failed to update note status'));
    }
  }

  Future<void> updateFavorite({
    required String noteId,
    required bool isFavorite,
  }) async {
    emit(NoteLoading());
    try {
      await noteRepo.updateFavorite(
        noteId: noteId,
        isFavorite: isFavorite,
        isHidden: false,
      );
      if (state is FavoritesLoaded) {
        loadFavorites();
      } else if (state is HiddenNotesLoaded) {
        loadHiddenNotes();
      } else {
        getAllNotes();
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

  Future<void> loadHiddenNotes() async {
    emit(NoteLoading());
    try {
      final result = await noteRepo.getAllNotes(userId.toString());
      result.fold(
            (error) => emit(NoteError(error)),
            (notes) {
          final hiddenNotes = notes.where((n) => n.isHidden).toList();
          emit(HiddenNotesLoaded(hiddenNotes));
        },
      );
    } catch (e) {
      emit(NoteError('Failed to load hidden notes'));
    }
  }


  // void selectWeight(FontWeight weight) {
  //   if (_textSelection != null && _textSelection!.isValid) {
  //     textStyles.add(TextStyleSelection(
  //       start: _textSelection!.start,
  //       end: _textSelection!.end,
  //       weight: weight,
  //     ));
  //     emit(TextStyleUpdated(textStyles));
  //     clearTextSelection();
  //   } else {
  //     defaultWeight = weight;
  //     emit(DefaultStyleUpdated(defaultWeight));
  //   }
  // }
}