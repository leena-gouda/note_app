import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/deleted/ui/cubit/deleted_cubit.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';

import '../../../home/ui/cubit/note_cubit.dart';

class DeletedNotesScreen extends StatelessWidget {
  const DeletedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash Bin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _showEmptyTrashConfirmation(context),
          ),
        ],
      ),
      body: BlocBuilder<DeletedCubit, DeletedState>(
        builder: (context, state) {
          if (state is DeletedNotesLoaded) {
            if (state.deletedNotes.isEmpty) {
              return const Center(child: Text('Trash bin is empty'));
            }
            return ListView.builder(
              itemCount: state.deletedNotes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(state.deletedNotes[index].noteId),
                  direction: DismissDirection.horizontal,
                  background: _buildRestoreBackground(),
                  secondaryBackground: _buildDeleteForeverBackground(),
                  child: CustomCardNote(note: state.deletedNotes[index]),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await _showRestoreConfirmation(context);
                    } else {
                      return await _showDeleteForeverConfirmation(context);
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      context.read<DeletedCubit>().restoreNote(state.deletedNotes[index].noteId.toString());
                    } else {
                      context.read<DeletedCubit>().permanentDelete(state.deletedNotes[index].noteId.toString());
                    }
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<bool?> _showDeleteForeverConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Delete Permanently?"),
        content: const Text("This will completely remove the note. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("DELETE FOREVER"),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRestoreConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Restore Note?"),
        content: const Text("This will move the note back to your main notes."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text("RESTORE"),
          ),
        ],
      ),
    );
  }
  Widget _buildDeleteForeverBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.w),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_forever, color: Colors.white, size: 30),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[400],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restore, color: Colors.white, size: 30),
          Text(
            'Restore',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEmptyTrashConfirmation(BuildContext context) async {
    final shouldEmpty = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Empty Trash?"),
        content: const Text("This will permanently delete all notes in trash. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("EMPTY TRASH"),
          ),
        ],
      ),
    );

    if (shouldEmpty == true) {
      context.read<DeletedCubit>().emptyTrash();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trash has been emptied')),
      );
    }
  }

}