import '../../../data/datasource/movies_datasource.dart';
import 'dashboard_notifiers.dart';

class DashboardController {
  final IMoviesDatasource _datasource;

  DashboardController(this._datasource);

  final yearsNotifier = YearsNotifier();

  final studiosNotifier = StudiosNotifier();

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
}
