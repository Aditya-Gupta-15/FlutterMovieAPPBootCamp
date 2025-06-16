part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;
  final int currentPage;
  final bool hasReachedMaxPage;

  MovieLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasReachedMaxPage,
  });
}

class MoviePaginationLoading extends MovieState {
  final List<MovieEntity> movies;
  final int currentPage;
  final bool hasReachedMaxPage; // Default to false for pagination loading

  MoviePaginationLoading({
    required this.movies,
    required this.currentPage,
    required this.hasReachedMaxPage,
  });
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}

class MoviePaginationError extends MovieState {
  final List<MovieEntity> movies;
  final int currentPage;
  final bool hasReachedMaxPage;
  final String error;

  MoviePaginationError({
    required this.movies,
    required this.currentPage,
    required this.hasReachedMaxPage,
    required this.error,
  });
}
