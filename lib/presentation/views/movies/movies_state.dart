import '../../../domain/entities/movie_entity.dart';
import '../../../domain/failures/custom_error.dart';

abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesSuccessState extends MoviesState {
  final List<MovieEntity> movies;
  final int totalPages;
  final bool isLoadingMore;
  final CustomError? loadMoreError;
  final bool hasMore;

  MoviesSuccessState({
    required this.movies,
    required this.totalPages,
    this.isLoadingMore = false,
    this.loadMoreError,
    required this.hasMore,
  });

  MoviesSuccessState copyWith({
    List<MovieEntity>? movies,
    int? totalPages,
    bool? isLoadingMore,
    CustomError? loadMoreError,
    bool? hasMore,
  }) {
    return MoviesSuccessState(
      movies: movies ?? this.movies,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class MoviesErrorState extends MoviesState {
  final CustomError error;

  MoviesErrorState({required this.error});
}
