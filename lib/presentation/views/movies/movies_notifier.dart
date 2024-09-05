import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/pagined_movies_entity.dart';
import '../../../domain/failures/custom_error.dart';
import 'movies_state.dart';

class MoviesNotifier extends ValueNotifier<MoviesState> {
  MoviesNotifier() : super(MoviesInitialState());

  Future<void> fetch(
    Future<Either<CustomError, PaginedMoviesEntity>> Function(
      String year, {
      required int page,
      required int size,
      required bool winner,
    }) getMoviesByYearPaginated,
    String year,
    bool winner,
  ) async {
    value = MoviesLoadingState();
    final result = await getMoviesByYearPaginated(
      year,
      page: 0,
      size: 10,
      winner: winner,
    );

    result.fold(
      (error) => value = MoviesErrorState(error: error),
      (moviesData) {
        value = MoviesSuccessState(
          movies: moviesData.content,
          totalPages: moviesData.totalPages,
          hasMore: moviesData.hasMore,
        );
      },
    );
  }

  Future<void> loadMore(
    Future<Either<CustomError, PaginedMoviesEntity>> Function(
      String year, {
      required int page,
      required int size,
      required bool winner,
    }) getMoviesByYearPaginated,
    String year,
    bool winner,
  ) async {
    if (value is MoviesSuccessState &&
        !(value as MoviesSuccessState).isLoadingMore) {
      final currentState = value as MoviesSuccessState;

      if (currentState.hasMore) {
        value = currentState.copyWith(isLoadingMore: true);

        final nextPage = currentState.movies.length;

        final result = await getMoviesByYearPaginated(
          year,
          page: nextPage,
          size: 10,
          winner: winner,
        );

        result.fold(
          (error) => value = MoviesErrorState(error: error),
          (moviesData) {
            final newMovies = moviesData.content;

            value = currentState.copyWith(
              movies: currentState.movies + newMovies,
              isLoadingMore: false,
              totalPages: moviesData.totalPages,
              hasMore: moviesData.hasMore,
            );
          },
        );
      }
    }
  }

  void clearMovies() {
    value = MoviesInitialState();
  }

  void setError(CustomError err) {
    value = MoviesErrorState(error: err);
  }
}
