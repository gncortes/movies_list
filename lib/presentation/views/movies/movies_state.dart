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

  MoviesSuccessState({
    required this.movies,
    required this.totalPages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  MoviesSuccessState copyWith({
    List<MovieEntity>? movies,
    int? totalPages,
    bool? isLoadingMore,
    CustomError? loadMoreError,
  }) {
    return MoviesSuccessState(
      movies: movies ?? this.movies,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
    );
  }
}

class MoviesErrorState extends MoviesState {
  final CustomError error;

  MoviesErrorState({required this.error});
}
