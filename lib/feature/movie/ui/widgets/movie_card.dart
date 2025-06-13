import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/feature/movie/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:movieapp/feature/movie/ui/pages/full_card_screen.dart';

Widget movieCardCreation(movies) {
  return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
      return BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          List favoriteIds = [];

          if (state is FavoriteLoaded) {
            favoriteIds = state.favoriteMovies
                .map((movie) => movie.id)
                .toList();
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1, // Adjust aspect ratio as needed
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return movieCardDataCreation(
                context: context,
                movie: movies[index],
                maxWidth: constraints.maxWidth,
                isFavorite: favoriteIds.contains(movies[index].id),
              );
            },
          );
        },
      );
    },
  );
}

Widget movieCardDataCreation({
  required BuildContext context,
  required movie,
  required double maxWidth,
  required isFavorite,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FullCardScreenCreation(movie: movie)),
      );
    },
    child: Card(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 2, child: movieImageCreation(movie.backdropPath)),
              Flexible(flex: 2, child: movieTextCreation(movie, maxWidth)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (isFavorite) {
                    context.read<FavoriteBloc>().add(
                      RemoveFromFavoritesEvent(movie.id),
                    );
                  } else {
                    context.read<FavoriteBloc>().add(
                      AddToFavoritesEvent(movie),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget movieImageCreation(backdropPath) {
  return Image.network(
    'https://image.tmdb.org/t/p/w200${backdropPath}',
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    },
  );
}

Widget movieTextCreation(movie, double maxWidth) {
  return Container(
    width: double.infinity,
    color: Colors.black54,
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          movie.title,
          style: TextStyle(
            fontSize: maxWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: maxWidth * 0.04),
            const SizedBox(width: 4),
            Text(
              movie.voteAverageRounded.toString(),
              style: TextStyle(fontSize: maxWidth * 0.04, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
