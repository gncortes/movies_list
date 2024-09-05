import 'package:flutter/foundation.dart';

import '../../../data/datasource/movies_datasource.dart';
import 'movies_notifier.dart';
import 'movies_state.dart';

class MoviesController {
  final IMoviesDatasource _datasource;

  final MoviesNotifier moviesNotifier = MoviesNotifier();

  final ValueNotifier<bool> winnerFilterNotifier = ValueNotifier(false);

  MoviesController(this._datasource);

  Future<void> getMoviesByYear(
    String year,
  ) async {
    if (moviesNotifier.value is MoviesSuccessState &&
        (moviesNotifier.value as MoviesSuccessState).isLoadingMore) {
      return;
    }

    if (moviesNotifier.value is! MoviesSuccessState) {
      await moviesNotifier.fetch(
        _datasource.getMoviesByYearPagined,
        year,
        winnerFilterNotifier.value,
      );
    } else {
      await moviesNotifier.loadMore(
        _datasource.getMoviesByYearPagined,
        year,
        winnerFilterNotifier.value,
      );
    }
  }

  void clearMovies() {
    moviesNotifier.clearMovies();
  }

  void setWinnerFilter(bool value) {
    winnerFilterNotifier.value = value;
  }
}
