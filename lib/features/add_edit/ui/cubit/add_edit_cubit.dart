import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/add_edit/data/repos/add_edit_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/note_req_add_model.dart';
import '../../../home/data/repos/note_repo.dart';
import '../../../home/data/repos/note_repo_imp.dart';
import '../../../home/ui/cubit/note_cubit.dart';
import '../../data/models/text_Style_model.dart';
import '../../data/models/text_style_range_model.dart';

part 'add_edit_state.dart';

class AddEditCubit extends Cubit<AddEditState> {
  final AddEditRepo addEditRepo;
  //final NoteCubit noteCubit = NoteCubit(NoteRepoImpl());

  AddEditCubit(this.addEditRepo) : super(AddEditInitial()) {
    getUserData();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  List<TextStyleRange> textStyle = [];
  TextSelection? _currentSelection;

  TextSelection? _textSelection;
  List<TextStyleSelection> textStyles = [];
  FontWeight defaultWeight = FontWeight.normal;

  String? userId;
  String? username;
  String? email;

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    print("userId : $userId");
    email = prefs.getString("email") ?? "";
    username = prefs.getString("username") ?? "";

    //noteCubit.getAllNotes();
  }

  Future<void> addNote({required String title, required String content}) async {
    if (title.isEmpty || content.isEmpty) {
      emit(NoteAddFailed("Validation failed - Title: $title, Content: $content"));
      return;
    }
    if (userId == null) {
      getUserData();
      emit(NoteAddEditError("User ID is not available") );
      return;
    }
    emit(AddNoteLoading());
    try {
      final message = await addEditRepo.addNote(
        NoteReqAddModel(
          title: title,
          content: content,
          userId: userId.toString(),
        ),
      );

      emit(NoteAddedSuccess(message));
     // noteCubit.getAllNotes();

    } catch (e) {
      emit(NoteAddEditError(e.toString()) );
      print(e);
    }


  }
  void editNote(String noteId) async {
    emit(NoteLoading() as AddEditState);
    try {
      final message = await addEditRepo.editeNote(noteId, titleController.text, contentController.text);
      emit(NoteEditSuccess(message)); // Clear the notes list
     // noteCubit.getAllNotes(); // Refresh the notes list
      titleController.clear();
      contentController.clear();
    } catch (e) {
      emit(NoteAddEditError(e.toString()) );
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

}
