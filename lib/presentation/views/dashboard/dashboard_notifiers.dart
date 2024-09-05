import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/studio_entity.dart';
import '../../../domain/entities/year_entity.dart';
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

abstract class DashboardComponentState {}

class ShowYearsState extends DashboardComponentState {}

class ShowStudiosState extends DashboardComponentState {}

class InitialState extends DashboardComponentState {}
