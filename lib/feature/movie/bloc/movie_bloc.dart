import 'package:flutter/widgets.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'package:movieapp/feature/movie/repository/movie_repository.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {

  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<FetchMoviesEvent>((event, emit) async {
      developer.log('🚀 [Bloc] FetchPopularMoviesEvent triggered', name: 'Bloc');


      emit(MovieLoading());
      try {
        final List<MovieEntity> movies = await movieRepository.getPopularMovies();
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError('Failed to load movies: $e'));
      }
    });
  }
}
