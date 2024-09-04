import '../../../data/datasource/movies_datasource.dart';
import 'dashboard_notifiers.dart';

class DashboardController {
  final IMoviesDatasource _datasource;

  DashboardController(this._datasource);

  final yearsNotifier = YearsNotifier();

  Future<void> fetch() {
    return yearsNotifier.getYearsWithMoreThanOneWinner(
      _datasource.getYearsWithMoreThanOneWinner,
    );
  }
}
