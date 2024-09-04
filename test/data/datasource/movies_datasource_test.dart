import 'package:flutter_test/flutter_test.dart';
import 'package:movies_list/data/datasource/movies_datasource.dart';
import 'package:movies_list/infrastructure/infrastructure.dart';

void main() {
  late IMoviesDatasource datasource;

  setUp(() {
    datasource = MoviesDatasource(HttpServiceImplementation());
  });
  test('shoud return a list of years with more than one winner', () async {
    final response = await datasource.getYearsWithMoreThanOneWinner();

    expect(response.isRight(), true);
  });
}
