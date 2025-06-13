
import 'package:hive/hive.dart';

part 'movie_entity.g.dart';

@HiveType(typeId: 0)
class MovieEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String overview;
  @HiveField(3)
  final String backdropPath;
  @HiveField(4)
  final String releaseDate;
  @HiveField(5)
  final double rating;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.backdropPath,
    required this.releaseDate,
    required this.rating,
  });

  String get voteAverageRounded => rating.toStringAsFixed(2);
}