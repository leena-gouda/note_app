import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/features/hidden/data/repos/hidden_repo.dart';
import 'package:note_app/features/home/ui/cubit/note_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../add_edit/data/models/text_Style_model.dart';
import '../../../add_edit/data/models/text_style_range_model.dart';
import '../../../favorites/ui/cubit/favorite_cubit.dart';
import '../../../home/data/models/notes_model.dart';
import '../../../home/data/repos/note_repo.dart';
import '../../../home/data/repos/note_repo_imp.dart';
import '../../data/repos/hidden_repo_impl.dart';



part 'hidden_state.dart';

class HiddenCubit extends Cubit<HiddenState> {
  final NoteRepo noteRepo;
  final HiddenRepo hiddenRepo = HiddenRepoImpl();
  final NoteCubit noteCubit = NoteCubit(NoteRepoImpl());

  HiddenCubit(this.noteRepo) : super(NoteInitial()) ;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NotesModel> notesList = [];




  String? userId;
  String? username;
  String? email;



  Future<void> updateHidden({
    required String noteId,
    required bool isHidden,
  }) async {
    emit(HiddenLoading());
    try {
      await hiddenRepo.updateHidden(
        noteId: noteId,
        isFavorite: false,
        isHidden: isHidden,
      );
      if (state is HiddenNotesLoaded) {
        loadHiddenNotes();
      } else {
        noteCubit.getAllNotes();
      }
    } catch (e) {
      emit(HiddenError('Failed to update note status'));
    }
  }


  Future<void> loadHiddenNotes() async {
    emit(HiddenLoading());
    try {
      final result = await noteRepo.getAllNotes(userId.toString());
      result.fold(
            (error) => emit(HiddenError(error)),
            (notes) {
          final hiddenNotes = notes.where((n) => n.isHidden).toList();
          emit(HiddenNotesLoaded(hiddenNotes));
        },
      );
    } catch (e) {
      emit(HiddenError('Failed to load hidden notes'));
    }
  }


}