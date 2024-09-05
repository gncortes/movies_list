import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/failures/custom_error.dart';
import 'dashboard_states.dart';

class YearsNotifier extends ValueNotifier<DashboardYearsState> {
  YearsNotifier() : super(DashboardYearsLoadingState());

  Future<void> fetch(
    Future<Either<CustomError, List<YearEntity>>> Function() fetchYears,
  ) async {
    value = DashboardYearsLoadingState();

    final result = await fetchYears();

    result.fold(
      (customError) {
        value = DashboardYearsErrorState(error: customError);
      },
      (yearsData) {
        value = DashboardYearsSuccessState(years: yearsData);
      },
    );
  }
}

class StudiosNotifier extends ValueNotifier<DashboardStudiosState> {
  StudiosNotifier() : super(DashboardStudiosLoadingState());

  Future<void> fetch(
    Future<Either<CustomError, List<StudioEntity>>> Function() fetchStudios,
  ) async {
    value = DashboardStudiosLoadingState();

    final result = await fetchStudios();

    result.fold(
      (customError) {
        value = DashboardStudiosErrorState(error: customError);
      },
      (studiosData) {
        value = DashboardStudiosSuccessState(studios: studiosData);
      },
    );
  }
}

class ProducerIntervalNotifier
    extends ValueNotifier<DashboardProducerIntervalState> {
  ProducerIntervalNotifier() : super(DashboardProducerIntervalLoadingState());

  Future<void> fetch(
    Future<Either<CustomError, ProducerIntervalDataEntity>> Function()
        fetchProducerInterval,
  ) async {
    value = DashboardProducerIntervalLoadingState();

    final result = await fetchProducerInterval();

    result.fold(
      (customError) {
        value = DashboardProducerIntervalErrorState(error: customError);
      },
      (producerIntervalData) {
        value = DashboardProducerIntervalSuccessState(producerIntervalData);
      },
    );
  }
}

class MovieSearchNotifier extends ValueNotifier<DashboardMovieSearchState> {
  MovieSearchNotifier() : super(DashboardMovieSearchInitialState());

  Future<void> fetch(
    Future<Either<CustomError, List<MovieEntity>>> Function(String)
        fetchMoviesByYear,
    String year,
  ) async {
    value = DashboardMovieSearchLoadingState();

    final result = await fetchMoviesByYear(year);

    result.fold(
      (customError) {
        value = DashboardMovieSearchErrorState(error: customError);
      },
      (movies) {
        value = DashboardMovieSearchSuccessState(movies: movies);
      },
    );
  }
}
