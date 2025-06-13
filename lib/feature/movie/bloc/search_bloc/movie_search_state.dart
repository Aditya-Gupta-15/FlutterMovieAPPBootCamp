part of 'movie_search_bloc.dart';

@immutable
abstract class MovieSearchState {}

final class MovieSearchInitial extends MovieSearchState {}

final class MovieSearchLoading extends MovieSearchState {}

final class MovieSearchLoaded extends MovieSearchState {
  final List<MovieEntity> movies;

  MovieSearchLoaded(this.movies);
}

final class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError(this.message);
}