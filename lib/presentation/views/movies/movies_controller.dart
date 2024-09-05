import 'package:flutter/material.dart';

import '../../../data/datasource/movies_datasource.dart';
import 'movies_notifier.dart';

class MoviesController {
  final IMoviesDatasource _datasource;

  MoviesController(this._datasource);

  final MoviesNotifier moviesNotifier = MoviesNotifier();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier(1);
  final ValueNotifier<bool> winnerFilterNotifier = ValueNotifier(false);

  int get currentPage => _currentPageNotifier.value;

  void getMoviesByYear(String year) {
    moviesNotifier.fetch(
      _datasource.getMoviesByYearPagined,
      year,
      _currentPageNotifier.value,
      winnerFilterNotifier.value,
    );
  }

  void nextPage(String year) {
    _currentPageNotifier.value++;
    getMoviesByYear(year);
  }

  void previousPage(String year) {
    if (_currentPageNotifier.value > 1) {
      _currentPageNotifier.value--;
      getMoviesByYear(year);
    }
  }

  void setWinnerFilter(bool isWinner) {
    winnerFilterNotifier.value = isWinner;
  }

  ValueNotifier<int> get currentPageNotifier => _currentPageNotifier;
}
