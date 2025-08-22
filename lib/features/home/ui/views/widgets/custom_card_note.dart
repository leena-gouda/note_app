import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/deleted/ui/cubit/deleted_cubit.dart';
import 'package:note_app/features/favorites/ui/cubit/favorite_cubit.dart';
import 'package:note_app/features/favorites/ui/views/favorite_screen.dart';
import 'package:note_app/features/hidden/ui/cubit/hidden_cubit.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/notes_model.dart';
import '../../cubit/note_cubit.dart';
import '../../../../deleted/ui/views/deleted_note.dart';
import '../../../../hidden/ui/views/hidden_screen.dart';

class CustomCardNote extends StatelessWidget {
  final NotesModel note;
  const CustomCardNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.noteId), // Use noteId as key instead of UniqueKey
      direction: DismissDirection.horizontal,
      background: _buildDeleteBackground(),
      secondaryBackground: _buildActionBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await _showDeleteConfirmation(context);
        } else {
          _showActionChoice(context);
          return false;
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final shouldDelete = await _showDeleteConfirmation(context);
          if (shouldDelete ?? false) {
            context.read<DeletedCubit>().deleteNote(note.noteId.toString());
          }
        }
      },
      child: _buildNoteCard(),
    );
  }

  void _showActionChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text(note.isFavorite ? 'Remove Favorite' : 'Mark as Favorite'),
              onTap: () {
                _setFavorite(context, !note.isFavorite);
                Navigator.pop(context);
                // Navigator.push(context,
                //   MaterialPageRoute(
                //     builder: (context) => const FavoritesScreen(),
                //   ),);
                // context.read<NoteCubit>().loadFavorites();
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility_off, color: Colors.blue),
              title: const Text('Hidden Notes'),
              onTap: () {
                _setHidden(context, !note.isHidden);
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HiddenNotesScreen(),
                //   ),
                // );
                // context.read<NoteCubit>().loadHiddenNotes();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      color: Colors.red[400],
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  Widget _buildActionBackground() {
    return Container(
      alignment: Alignment.centerRight,
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: const Icon(Icons.more_horiz, color: Colors.grey, size: 30),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Move to Trash?"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This note will be moved to trash"),
            SizedBox(height: 8),
            Text("You can restore it later"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("MOVE TO TRASH"),
          ),
        ],
      ),
    );
  }

  void _showActionSnackbar(BuildContext context,{required bool isFavoriteAction, required bool newValue}) {
    final actionType = isFavoriteAction ? 'favorite' : 'hidden';
    final actionMessage = newValue
        ? isFavoriteAction ? 'Added to favorites' : 'Note hidden'
        : isFavoriteAction ? 'Removed from favorites' : 'Note unhidden';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(actionMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: isFavoriteAction ? 'VIEW FAVORITES' : 'VIEW HIDDEN',
          textColor: Colors.amber,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isFavoriteAction
                    ? const FavoritesScreen()
                    : const HiddenNotesScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _setFavorite(BuildContext context, bool value) {
    context.read<FavoriteCubit>().updateFavorite(
      noteId: note.noteId.toString(),
      isFavorite: value,
    );
    _showActionSnackbar(context, isFavoriteAction: true, newValue: value);
  }

  void _setHidden(BuildContext context, bool value) {
    context.read<HiddenCubit>().updateHidden(
      noteId: note.noteId.toString(),
      isHidden: value,
    );
    _showActionSnackbar(context, isFavoriteAction: false, newValue: value, );

  }

  Widget _buildNoteCard() {
    return Card(
      elevation: 4,
      color: note.isHidden ? Colors.grey[100] : Colors.white,
      shadowColor: note.isFavorite ? Colors.amber : AppColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNoteHeader(),
            SizedBox(height: 12.h),
            _buildNoteTitle(),
            SizedBox(height: 8.h),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 8.h),
            _buildNoteContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.note, color: Colors.teal),
            if (note.isFavorite)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: const Icon(Icons.star, color: Colors.amber, size: 20),
              ),
            if (note.isHidden)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: const Icon(Icons.visibility_off, color: Colors.blue, size: 20),
              ),
          ],
        ),
        Text(
          note.createdAt?.split(" ").first ?? "",
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildNoteTitle() {
    return Text(
      note.title ?? "No Title",
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: note.isHidden ? Colors.grey : Colors.black,
      ),
    );
  }

  Widget _buildNoteContent() {
    return Text(
      note.content ?? "No content",
      style: TextStyle(
        fontSize: 14.sp,
        color: note.isHidden ? Colors.grey : Colors.black87,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}