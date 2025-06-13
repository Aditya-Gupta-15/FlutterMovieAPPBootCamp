import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'package:movieapp/feature/movie/repository/movie_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc(this.favoriteRepository) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final favorites = await favoriteRepository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await favoriteRepository.addFavorite(event.movie);
      final favorites = await favoriteRepository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to add to favorites: $e'));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await favoriteRepository.removeFavorite(event.movieId);
      final favorites = await favoriteRepository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to remove from favorites: $e'));
    }
  }
}
