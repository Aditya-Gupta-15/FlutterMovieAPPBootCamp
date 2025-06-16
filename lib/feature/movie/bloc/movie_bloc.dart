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
    on<FetchMoviesEvent>(_onFetchMovies);
    on<FetchNextPageEvent>(_onFetchNextPage);
  }

  Future <void> _onFetchMovies(FetchMoviesEvent event, Emitter<MovieState> emit) async {
      developer.log('🚀 [Bloc] FetchMoviesEvent triggered', name: 'Bloc');

      emit(MovieLoading());
      try {
        final List<MovieEntity> movies = await movieRepository.getPopularMovies(page : 1);
        emit(MovieLoaded(movies: movies, currentPage: 1, hasReachedMaxPage: movies.length < 20));
      } catch (e) {
        emit(MovieError('Failed to load movies: $e'));
      }
    }

    Future<void> _onFetchNextPage(FetchNextPageEvent event, Emitter<MovieState> emit) async {
      final currentState = state; 

      if(currentState is MovieLoaded && !currentState.hasReachedMaxPage){
        try{
          emit(MoviePaginationLoading(movies: currentState.movies, currentPage: currentState.currentPage, hasReachedMaxPage: currentState.hasReachedMaxPage));
          final nextPage = currentState.currentPage + 1;
          final List<MovieEntity> movies = await movieRepository.getPopularMovies(page: nextPage);
          
          if (movies.isEmpty) {
            emit(MovieLoaded(movies: currentState.movies, currentPage: currentState.currentPage, hasReachedMaxPage: true));
          } else {
            emit(MovieLoaded(
              movies: List.from(currentState.movies)..addAll(movies),
              currentPage: nextPage,
              hasReachedMaxPage: movies.length < 20,
            ));
          }
        } catch (e) {
          emit(MovieError('Failed to load more movies: $e'));
        }
      }
    }
}

