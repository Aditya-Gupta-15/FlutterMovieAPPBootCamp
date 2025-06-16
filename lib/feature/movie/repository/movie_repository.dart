import 'package:hive/hive.dart';
import 'package:movieapp/core/api/api_service.dart';
import 'package:movieapp/core/api/network_models/movie_model.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'package:movieapp/feature/movie/repository/mappers/movie_mapper.dart';

class MovieRepository {
  final ApiService apiService;
  final MovieMapper movieMapper;

  MovieRepository({
    required this.apiService,
    required this.movieMapper,
  });

  Future<List<MovieEntity>> getPopularMovies({required int page}) async {
    try {
      // Call ApiService -> returns list of MovieNetworkModel
      final List<MovieNetworkModel> jsonResponse = await apiService.getPopularMovies(page : page);

      // Map each MovieNetworkModel to MovieEntity using the mapper
      final List<MovieEntity> movies = jsonResponse
          .map((networkModel) => movieMapper.toMovieEntity(networkModel))
          .toList();

      // Return list of MovieEntity
      return movies;
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  Future<List<MovieEntity>> searchMovies(String query) async {
    try {
      // Call ApiService -> returns list of MovieNetworkModel
      final List<MovieNetworkModel> jsonResponse = await apiService.searchMovieApiService(query);

      // Map each MovieNetworkModel to MovieEntity using the mapper
      final List<MovieEntity> movies = jsonResponse
          .map((networkModel) => movieMapper.toMovieEntity(networkModel))
          .toList();

      // Return list of MovieEntity
      return movies;
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}
class FavoriteRepository {
  static const String _boxName = 'favoriteMovies';

  late Box<MovieEntity> _favoritesBox;

  Future<void> init() async {
    _favoritesBox = await Hive.openBox<MovieEntity>(_boxName);
  }

  Future<List<MovieEntity>> getFavorites() async {
    return _favoritesBox.values.toList();
  }

  Future<void> addFavorite(MovieEntity movie) async {
    await _favoritesBox.put(movie.id, movie);
  }

  Future<void> removeFavorite(int movieId) async {
    await _favoritesBox.delete(movieId);
  }

  bool isFavorite(int movieId) {
    return _favoritesBox.containsKey(movieId);
  }
}