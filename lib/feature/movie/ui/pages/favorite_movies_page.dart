import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/feature/movie/ui/widgets/movie_card.dart';
import 'package:movieapp/feature/movie/bloc/favorite_bloc/favorite_bloc.dart';

class FavoriteMoviesPage extends StatelessWidget {
  const FavoriteMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            final favoriteMovies = state.favoriteMovies;
            if (favoriteMovies.isEmpty) {
              return const Center(child: Text('No favorite movies yet.'));
            }
            return movieCardCreation(state.favoriteMovies);
          } else if (state is FavoriteError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
