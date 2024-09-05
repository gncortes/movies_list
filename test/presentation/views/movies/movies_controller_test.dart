import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_list/data/datasource/movies_datasource.dart';
import 'package:movies_list/data/models/models.dart';
import 'package:dartz/dartz.dart';
import 'package:movies_list/domain/failures/custom_http_exceptions.dart';
import 'package:movies_list/presentation/views/movies/movies_controller.dart';
import 'package:movies_list/presentation/views/movies/movies_notifier.dart';
import 'package:movies_list/presentation/views/movies/movies_state.dart';

import 'movies_controller_test.mocks.dart';

@GenerateMocks([IMoviesDatasource, PaginedMoviesModel])
void main() {
  late MoviesController controller;
  late IMoviesDatasource mockDatasource;
  late MoviesNotifier mockNotifier;
  late PaginedMoviesModel mockPaginedMoviesEntity;

  setUp(() {
    mockDatasource = MockIMoviesDatasource();
    controller = MoviesController(mockDatasource);
    mockNotifier = controller.moviesNotifier;
    mockPaginedMoviesEntity = MockPaginedMoviesModel();
  });

  group('MoviesController', () {
    const String testYear = '1990';
    const int page = 0;
    const int size = 10;
    const bool winner = false;

    test('should fetch movies successfully and update notifier state',
        () async {
      when(mockDatasource.getMoviesByYearPagined(
        testYear,
        page: page,
        size: size,
        winner: winner,
      )).thenAnswer((_) async => Right(mockPaginedMoviesEntity));

      await controller.getMoviesByYear(testYear);

      expect(mockNotifier.value, isA<MoviesSuccessState>());
    });

    test('should set error state when fetching movies fails', () async {
      when(mockDatasource.getMoviesByYearPagined(
        testYear,
        page: page,
        size: size,
        winner: winner,
      )).thenThrow(DefaultException());

      await controller.getMoviesByYear(testYear);

      expect(mockNotifier.value, isA<MoviesErrorState>());
      expect(
        (mockNotifier.value as MoviesErrorState).error.message,
        'Aconteceu um erro inesperado',
      );
    });

    test('should clear movies when calling clearMovies', () {
      controller.clearMovies();

      expect(mockNotifier.value, isA<MoviesInitialState>());
    });

    test('should update winnerFilterNotifier value', () {
      controller.setWinnerFilter(true);

      expect(controller.winnerFilterNotifier.value, true);
    });
  });
}
