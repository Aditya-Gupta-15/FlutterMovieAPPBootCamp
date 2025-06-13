part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class LoadFavoritesEvent extends FavoriteEvent {}

class AddToFavoritesEvent extends FavoriteEvent {
  final MovieEntity movie;

  AddToFavoritesEvent(this.movie);
}
class RemoveFromFavoritesEvent extends FavoriteEvent {
  final int movieId;

  RemoveFromFavoritesEvent(this.movieId);
}
