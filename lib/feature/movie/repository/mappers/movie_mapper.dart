import 'package:movieapp/core/api/network_models/movie_model.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
import 'dart:developer' as developer;

class MovieMapper {
  MovieEntity toMovieEntity(MovieNetworkModel model){
    
    developer.log('🔄 [Mapper] Mapping MovieNetworkModel -> MovieEntity: id=${model.id}', name: 'Mapper');

    return MovieEntity(
      id: model.id, 
      title: model.title, 
      overview: model.overview, 
      backdropPath: model.backdropPath,
      releaseDate: model.releaseDate,
      rating: model.voteAverage,
      );
  }
}