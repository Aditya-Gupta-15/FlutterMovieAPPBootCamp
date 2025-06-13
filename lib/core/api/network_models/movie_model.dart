class MovieNetworkModel {
    final int id;
    final String title;
    final String overview;
    final String backdropPath;
    final String releaseDate;
    final double voteAverage;

    MovieNetworkModel({
        required this.id,
        required this.title,
        required this.overview,
        required this.backdropPath,
        required this.releaseDate,
        required this.voteAverage,
    });

    factory MovieNetworkModel.fromJson(Map<String, dynamic> json) {
        return MovieNetworkModel(
            id: json['id'] ,
            title: json['title'],
            overview: json['overview']??"",
            backdropPath: json['backdrop_path']??"",
            releaseDate: json['release_date']??"",
            voteAverage: (json['vote_average'] ?? 0).toDouble(),
        );
    }

    String get voteAverageRounded{return voteAverage.toStringAsFixed(2);}
}