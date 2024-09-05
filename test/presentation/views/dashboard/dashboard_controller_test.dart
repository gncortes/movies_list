import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:movies_list/data/datasource/movies_datasource.dart';
import 'package:movies_list/data/models/models.dart';
import 'package:movies_list/domain/failures/custom_error.dart';
import 'package:movies_list/presentation/views/dashboard/dashboard_controller.dart';
import 'package:movies_list/presentation/views/dashboard/dashboard_states.dart';

import 'dashboard_controller_test.mocks.dart';

@GenerateMocks([IMoviesDatasource])
void main() {
  late DashboardController controller;
  late IMoviesDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockIMoviesDatasource();
    controller = DashboardController(mockDatasource);
  });

  group('DashboardController', () {
    const customError = CustomError(message: 'Erro personalizado');

    test('should fetch years with more than one winner successfully', () async {
      final years = [YearModel(year: 1990, winnerCount: 2)];

      when(mockDatasource.getYearsWithMoreThanOneWinner())
          .thenAnswer((_) async => Right(years));

      await controller.getYearsWithMoreThanOneWinner();

      expect(controller.yearsNotifier.value, isA<DashboardYearsSuccessState>());
      final successState =
          controller.yearsNotifier.value as DashboardYearsSuccessState;
      expect(successState.years, years);
    });

    test('should set error state when fetching years fails', () async {
      when(mockDatasource.getYearsWithMoreThanOneWinner())
          .thenAnswer((_) async => const Left(customError));

      await controller.getYearsWithMoreThanOneWinner();

      expect(controller.yearsNotifier.value, isA<DashboardYearsErrorState>());
      final errorState =
          controller.yearsNotifier.value as DashboardYearsErrorState;
      expect(errorState.error.message, 'Erro personalizado');
    });

    test('should fetch studios with the most wins successfully', () async {
      final studios = [StudioModel(name: 'Studio A', winCount: 10)];

      when(mockDatasource.getStudiosWithTheMostWins())
          .thenAnswer((_) async => Right(studios));

      await controller.getStudiosWithTheMostWins();

      expect(controller.studiosNotifier.value,
          isA<DashboardStudiosSuccessState>());
      final successState =
          controller.studiosNotifier.value as DashboardStudiosSuccessState;
      expect(successState.studios, studios);
    });

    test('should set error state when fetching studios fails', () async {
      when(mockDatasource.getStudiosWithTheMostWins())
          .thenAnswer((_) async => const Left(customError));

      await controller.getStudiosWithTheMostWins();

      expect(
          controller.studiosNotifier.value, isA<DashboardStudiosErrorState>());
      final errorState =
          controller.studiosNotifier.value as DashboardStudiosErrorState;
      expect(errorState.error.message, 'Erro personalizado');
    });

    test('should fetch producer interval data successfully', () async {
      final producerInterval = ProducerIntervalDataModel(
        min: [
          ProducerIntervalModel(
            producer: 'Producer A',
            interval: 1,
            previousWin: 5,
            followingWin: 10,
          )
        ],
        max: [
          ProducerIntervalModel(
            producer: 'Producer B',
            interval: 10,
            previousWin: 5,
            followingWin: 10,
          )
        ],
      );

      when(mockDatasource.getMoviesAwardsRange())
          .thenAnswer((_) async => Right(producerInterval));

      await controller.getMoviesAwardsRange();

      expect(controller.producerIntervalNotifier.value,
          isA<DashboardProducerIntervalSuccessState>());
      final successState = controller.producerIntervalNotifier.value
          as DashboardProducerIntervalSuccessState;
      expect(successState.producerIntervalData, producerInterval);
    });

    test('should set error state when fetching producer interval fails',
        () async {
      when(mockDatasource.getMoviesAwardsRange())
          .thenAnswer((_) async => const Left(customError));

      await controller.getMoviesAwardsRange();

      expect(controller.producerIntervalNotifier.value,
          isA<DashboardProducerIntervalErrorState>());
      final errorState = controller.producerIntervalNotifier.value
          as DashboardProducerIntervalErrorState;
      expect(errorState.error.message, 'Erro personalizado');
    });

    test('should update selectedComponentNotifier to ShowYearsState', () {
      when(mockDatasource.getYearsWithMoreThanOneWinner())
          .thenAnswer((_) async => const Left(customError));
      controller.showYears();

      expect(controller.selectedComponentNotifier.value, isA<ShowYearsState>());
    });

    test('should update selectedComponentNotifier to ShowStudiosState', () {
      when(mockDatasource.getStudiosWithTheMostWins())
          .thenAnswer((_) async => const Left(customError));
      controller.showStudios();

      expect(
          controller.selectedComponentNotifier.value, isA<ShowStudiosState>());
    });

    test('should update selectedComponentNotifier to ShowProducerIntervalState',
        () {
      when(mockDatasource.getMoviesAwardsRange())
          .thenAnswer((_) async => const Left(customError));
      controller.showMoviesAwardRange();

      expect(controller.selectedComponentNotifier.value,
          isA<ShowProducerIntervalState>());
    });

    test('should search movies by year successfully', () async {
      final movies = [
        MovieModel(
          id: 1,
          title: 'Movie A',
          year: 1990,
          studios: [],
          producers: [],
          winner: true,
        )
      ];

      when(mockDatasource.getMoviesByYear('1990'))
          .thenAnswer((_) async => Right(movies));

      await controller.searchMoviesByYear('1990');

      expect(controller.movieSearchNotifier.value,
          isA<DashboardMovieSearchSuccessState>());
      final successState = controller.movieSearchNotifier.value
          as DashboardMovieSearchSuccessState;
      expect(successState.movies, movies);
    });

    test('should set error state when searching movies by year fails',
        () async {
      when(mockDatasource.getMoviesByYear('1990'))
          .thenAnswer((_) async => const Left(customError));

      await controller.searchMoviesByYear('1990');

      expect(controller.movieSearchNotifier.value,
          isA<DashboardMovieSearchErrorState>());
      final errorState = controller.movieSearchNotifier.value
          as DashboardMovieSearchErrorState;
      expect(errorState.error.message, 'Erro personalizado');
    });
  });
}
