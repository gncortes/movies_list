import 'package:flutter/material.dart';

import '../../../data/datasource/movies_datasource.dart';
import 'movies_notifier.dart';

class MoviesController {
  final IMoviesDatasource _datasource;

  MoviesController(this._datasource);

  final MoviesNotifier moviesNotifier = MoviesNotifier();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier(1);
  final ValueNotifier<bool> winnerFilterNotifier = ValueNotifier(false);

  bool isLoading = false;
  bool hasMore = true;

  void resetPage() {
    _currentPageNotifier.value = 1;
    hasMore = true;
    moviesNotifier.clearMovies();
  }

  void getMoviesByYear(String year) async {
    if (!isLoading) {
      isLoading = true;
      final result = await _datasource.getMoviesByYearPagined(
        year,
        page: _currentPageNotifier.value,
        size: 10,
      );

      result.fold(
        (error) {
          isLoading = false;
          moviesNotifier.setError(error);
        },
        (moviesData) {
          isLoading = false;
          _currentPageNotifier.value++;
          hasMore = moviesData.hasMore;
          moviesNotifier.addMovies(
            moviesData.content,
            moviesData.totalElements,
          ); // Adiciona novos filmes à lista existente
        },
      );
    }
  }

  void nextPage(String year) {
    getMoviesByYear(year);
  }

  void setWinnerFilter(bool isWinner) {
    winnerFilterNotifier.value = isWinner;
  }
}
