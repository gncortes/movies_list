import '../../domain/entities/pagined_movies_entity.dart';
import 'movie_model.dart';

class PaginedMoviesModel extends PaginedMoviesEntity {
  PaginedMoviesModel({
    required super.content,
    required super.pageNumber,
    required super.totalPages,
    required super.hasMore,
    required super.totalElements,
  });

  factory PaginedMoviesModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return PaginedMoviesModel(
      content: (json['content'] as List)
          .map((movieJson) => MovieModel.fromJson(movieJson))
          .toList(),
      pageNumber: json['pageable']['pageNumber'],
      totalPages: json['totalPages'],
      hasMore: !json['last'],
      totalElements: json['totalElements'],
    );
  }
}
