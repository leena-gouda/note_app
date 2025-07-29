import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/notes_model.dart';
import '../../data/repos/note_repo.dart';



part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepo noteRepo;

  NoteCubit(this.noteRepo) : super(NoteInitial());


  void getAllNotes() async{
    emit(NoteLoading());
    try {
      final notes = await noteRepo.getAllNotes(2.toString());
      emit(NoteSuccess(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
      print(e);
    }
  }
}