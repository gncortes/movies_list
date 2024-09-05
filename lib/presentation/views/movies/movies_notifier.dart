import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

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
    }) getMovies,
    String year,
    int page,
    bool winnerFilter,
  ) async {
    value = MoviesLoadingState();

    final result = await getMovies(year, page: page, size: 10);

    result.fold(
      (error) => value = MoviesErrorState(error: error),
      (moviesData) {
        final filteredMovies = winnerFilter
            ? moviesData.content.where((movie) => movie.winner).toList()
            : moviesData.content;
        value = MoviesSuccessState(
          movies: filteredMovies,
          totalPages: moviesData.totalPages,
        );
      },
    );
  }
}
