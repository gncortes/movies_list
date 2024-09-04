import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    required super.id,
    required super.year,
    required super.title,
    required super.studios,
    required super.producers,
    required super.winner,
  });

  MovieModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          year: json['year'],
          title: json['title'],
          studios: List<String>.from(json['studios']),
          producers: List<String>.from(json['producers']),
          winner: json['winner'],
        );
}
