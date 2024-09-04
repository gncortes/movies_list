import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/year_entity.dart';
import '../../../domain/failures/custom_error.dart';
import 'dashboard_states.dart';

class YearsNotifier extends ValueNotifier<DashboardYearsState> {
  YearsNotifier() : super(DashboardYearsLoadingState());

  Future<void> getYearsWithMoreThanOneWinner(
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
