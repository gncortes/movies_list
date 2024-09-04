import 'movie_entity.dart';

class PaginedMoviesEntity {
  final List<MovieEntity> content;
  final int pageNumber;
  final int totalPages;
  final bool hasMore;
  final int totalElements;

  PaginedMoviesEntity({
    required this.content,
    required this.pageNumber,
    required this.totalPages,
    required this.hasMore,
    required this.totalElements,
  });
}
