import 'package:flutter/material.dart';

import '../../../data/datasource/movies_datasource.dart';
import 'dashboard_notifiers.dart';
import 'dashboard_states.dart';

class DashboardController {
  final IMoviesDatasource _datasource;

  DashboardController(this._datasource);

  final yearsNotifier = YearsNotifier();

  final studiosNotifier = StudiosNotifier();

  final producerIntervalNotifier = ProducerIntervalNotifier();

  final movieSearchNotifier = MovieSearchNotifier();

  final selectedComponentNotifier =
      ValueNotifier<DashboardComponentState>(InitialState());

  Future<void> getYearsWithMoreThanOneWinner() {
    return yearsNotifier.fetch(
      _datasource.getYearsWithMoreThanOneWinner,
    );
  }

  Future<void> getStudiosWithTheMostWins() {
    return studiosNotifier.fetch(
      _datasource.getStudiosWithTheMostWins,
    );
  }

  Future<void> getMoviesAwardsRange() {
    return producerIntervalNotifier.fetch(
      _datasource.getMoviesAwardsRange,
    );
  }

  void showYears() {
    selectedComponentNotifier.value = ShowYearsState();
    getYearsWithMoreThanOneWinner();
  }

  void showStudios() {
    selectedComponentNotifier.value = ShowStudiosState();
    getStudiosWithTheMostWins();
  }

  void showMoviesAwardRange() {
    selectedComponentNotifier.value = ShowProducerIntervalState();
    getMoviesAwardsRange();
  }

  void showMoviesByYearSearch() {
    selectedComponentNotifier.value = ShowMoviesByYearSearchState();
  }

  Future<void> searchMoviesByYear(String year) {
    return movieSearchNotifier.fetch(
      _datasource.getMoviesByYear,
      year,
    );
  }
}
