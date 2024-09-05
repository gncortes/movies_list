import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/pagined_movies_entity.dart';
import '../../../domain/failures/custom_error.dart';
import 'movies_state.dart';

class MoviesNotifier extends ValueNotifier<MoviesState> {
  MoviesNotifier() : super(MoviesInitialState());

  final List<MovieEntity> _movies = [];

  Future<void> fetch(
    Future<Either<CustomError, PaginedMoviesEntity>> Function(
      String year, {
      required int page,
      required int size,
    }) getMoviesByYearPaginated,
    String year,
    int page,
    bool winnerFilter,
  ) async {
    value = MoviesLoadingState();
    final result = await getMoviesByYearPaginated(year, page: page, size: 10);

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

  void addMovies(List<MovieEntity> newMovies, int totalPages) {
    _movies.addAll(newMovies);
    value = MoviesSuccessState(movies: _movies, totalPages: totalPages);
  }

  void clearMovies() {
    _movies.clear();
    value = MoviesInitialState();
  }

  void setError(CustomError err) {
    value = MoviesErrorState(error: err);
  }
}
