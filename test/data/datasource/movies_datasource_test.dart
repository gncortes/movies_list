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

  test('shoud return a list of studios with more than one winner', () async {
    final response = await datasource.getStudiosWithTheMostWins();

    expect(response.isRight(), true);
  });

  group('shoud test movie by year', () {
    test('shoud return a movie', () async {
      final response = await datasource.getMoviesByYear('2018');

      expect(response.isRight(), true);
    });

    test('shoud not return a movie', () async {
      final response = await datasource.getMoviesByYear('1');

      expect(response.isRight(), false);
    });
  });

  test('shoud return a movies award range', () async {
    final response = await datasource.getMoviesAwardsRange();

    expect(response.isRight(), true);
  });

  test('shoud return a list of movies', () async {
    final response = await datasource.getMoviesByYearPagined(
      '2018',
      page: 1,
      size: 10,
    );

    expect(response.isRight(), true);
  });
}
