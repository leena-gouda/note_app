import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';

import '../../../home/ui/cubit/note_cubit.dart';
import '../cubit/hidden_cubit.dart';

class HiddenNotesScreen extends StatelessWidget {
  const HiddenNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hidden Notes')),
      body: BlocBuilder<HiddenCubit, HiddenState>(
        builder: (context, state) {
          if (state is HiddenNotesLoaded) {
            if (state.hiddenNotes.isEmpty) {
              return const Center(child: Text('No hidden notes'));
            }
            return ListView.builder(
              itemCount: state.hiddenNotes.length,
              itemBuilder: (context, index) => CustomCardNote(note: state.hiddenNotes[index]),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}