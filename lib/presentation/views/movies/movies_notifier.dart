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
    }) getMoviesByYearPaginated,
    String year,
    bool winnerFilter,
  ) async {
    value = MoviesLoadingState();
    final result = await getMoviesByYearPaginated(year, page: 1, size: 10);

    result.fold(
      (error) => value = MoviesErrorState(error: error),
      (moviesData) {
        value = MoviesSuccessState(
          movies: winnerFilter
              ? moviesData.content.where((movie) => movie.winner).toList()
              : moviesData.content,
          totalPages: moviesData.totalPages,
        );
      },
    );
  }

  Future<void> loadMore(
    Future<Either<CustomError, PaginedMoviesEntity>> Function(
      String year, {
      required int page,
      required int size,
    }) getMoviesByYearPaginated,
    String year,
    bool winnerFilter,
  ) async {
    if (value is MoviesSuccessState &&
        !(value as MoviesSuccessState).isLoadingMore) {
      final currentState = value as MoviesSuccessState;

      // Verifica se ainda existem mais páginas a serem carregadas
      if (currentState.movies.length / 10 < currentState.totalPages) {
        value = currentState.copyWith(isLoadingMore: true);

        final nextPage = (currentState.movies.length ~/ 10) + 1;
        final result =
            await getMoviesByYearPaginated(year, page: nextPage, size: 10);

        result.fold(
          (error) {
            value = currentState.copyWith(
              isLoadingMore: false,
              loadMoreError: error,
            );
          },
          (moviesData) {
            final newMovies = winnerFilter
                ? moviesData.content.where((movie) => movie.winner).toList()
                : moviesData.content;

            value = currentState.copyWith(
              movies: currentState.movies + newMovies,
              isLoadingMore: false,
              totalPages: moviesData.totalPages,
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
