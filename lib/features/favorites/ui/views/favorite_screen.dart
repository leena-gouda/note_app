import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/favorites/ui/cubit/favorite_cubit.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';

import '../../../home/ui/cubit/note_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Notes')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorite notes'));
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) => CustomCardNote(note: state.favorites[index]),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}