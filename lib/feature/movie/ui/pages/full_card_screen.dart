import 'package:flutter/material.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';

class FullCardScreenCreation extends StatelessWidget {
  final MovieEntity movie;
  
  const FullCardScreenCreation({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://image.tmdb.org/t/p/w500${movie.backdropPath}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('⭐ ${movie.rating}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Release Date: ${movie.releaseDate}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.overview),
            ),
          ],
        ),
      ),
    );
  }
}