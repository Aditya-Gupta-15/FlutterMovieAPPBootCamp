part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}

class FetchMoviesEvent extends MovieEvent {
  final int page;

  FetchMoviesEvent({this.page = 1});
}

class FetchNextPageEvent extends MovieEvent {
  final int nextPage;

  FetchNextPageEvent({required this.nextPage});
}


