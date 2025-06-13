import 'package:movieapp/core/api/api_service.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'package:movieapp/feature/movie/repository/movie_repository.dart';
import 'package:movieapp/feature/movie/repository/mappers/movie_mapper.dart';
import 'package:movieapp/feature/movie/bloc/movie_bloc.dart';
import 'package:movieapp/feature/movie/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppDI {
  static late ApiService _apiService;
  static late MovieMapper _movieMapper;
  static late MovieRepository _movieRepository;
  static late FavoriteRepository _favoriteRepository;
  static late MovieBloc _movieBloc;
  static late FavoriteBloc _favoriteBloc;

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(MovieEntityAdapter());
    await Hive.openBox<MovieEntity>('favoriteMovies');

    // Initialize dependencies once
    _apiService = ApiService();
    _movieMapper = MovieMapper();
    _movieRepository = MovieRepository(apiService: _apiService, movieMapper: _movieMapper);
    _favoriteRepository = FavoriteRepository();
    await _favoriteRepository.init();

    _movieBloc = MovieBloc(movieRepository: _movieRepository);
    _favoriteBloc = FavoriteBloc(_favoriteRepository)..add(LoadFavoritesEvent());
  }

  // Expose dependencies

  static MovieRepository provideMovieRepository() => _movieRepository;

  static MovieBloc provideMovieBloc() => _movieBloc;

  static FavoriteBloc provideFavoriteBloc() => _favoriteBloc;
}
