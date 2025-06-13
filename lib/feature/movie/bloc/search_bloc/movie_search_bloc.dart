import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'package:movieapp/feature/movie/repository/movie_repository.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  
  final MovieRepository movieRepository;
  
  MovieSearchBloc(this.movieRepository) : super(MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<ClearSearchEvent>((event,emit) {
      emit(MovieSearchInitial());
    });
  }

  Future<void> _onSearchMovies(SearchMoviesEvent event, Emitter<MovieSearchState> emit) async {
    emit(MovieSearchLoading());
    try {
      final List<MovieEntity> movies = await movieRepository.searchMovies(event.query);
      if (movies.isEmpty) {
        emit(MovieSearchError('No movies found for "${event.query}"'));
      } else {
        emit(MovieSearchLoaded(movies));
      }
    } catch (e) {
      emit(MovieSearchError('Failed to search movies: $e'));
    }
  }
}
