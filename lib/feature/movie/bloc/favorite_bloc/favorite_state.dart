part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<MovieEntity> favoriteMovies;

  FavoriteLoaded(this.favoriteMovies);
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}