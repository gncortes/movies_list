import '../../../domain/entities/entities.dart';
import '../../../domain/failures/custom_error.dart';

abstract class DashboardYearsState {}

class DashboardYearsLoadingState extends DashboardYearsState {}

class DashboardYearsSuccessState extends DashboardYearsState {
  final List<YearEntity> years;

  DashboardYearsSuccessState({required this.years});
}

class DashboardYearsErrorState extends DashboardYearsState {
  final CustomError error;

  DashboardYearsErrorState({required this.error});
}

abstract class DashboardStudiosState {}

class DashboardStudiosLoadingState extends DashboardStudiosState {}

class DashboardStudiosSuccessState extends DashboardStudiosState {
  final List<StudioEntity> studios;

  DashboardStudiosSuccessState({required this.studios});
}

class DashboardStudiosErrorState extends DashboardStudiosState {
  final CustomError error;

  DashboardStudiosErrorState({required this.error});
}
