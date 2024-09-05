import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_list/data/datasource/movies_datasource.dart';
import 'package:movies_list/data/models/models.dart';
import 'package:movies_list/domain/failures/custom_error.dart';
import 'package:movies_list/domain/failures/failures.dart';
import 'package:movies_list/infrastructure/infrastructure.dart';

class MockHttpService extends Mock implements IHttpService {}

void main() {
  late IMoviesDatasource datasource;
  late IHttpService mockHttpService;

  const path = 'movies';

  setUp(() {
    mockHttpService = MockHttpService();
    datasource = MoviesDatasource(mockHttpService);
  });

  group('getYearsWithMoreThanOneWinner', () {
    test('should return a list of YearModel on success', () async {
      when(
        mockHttpService.get(
          path,
          queryParameters: {
            'projection': 'years-with-multiple-winners',
          },
        ),
      ).thenAnswer((_) async => {
            'years': [
              {'year': '1990'},
              {'year': '2000'}
            ]
          });

      final result = await datasource.getYearsWithMoreThanOneWinner();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<YearModel>>());
    });

    test('should return CustomError when the list is not found', () async {
      when(mockHttpService.get(
        path,
        queryParameters: {
          'projection': 'years-with-multiple-winners',
        },
      )).thenAnswer((_) async => {});

      final result = await datasource.getYearsWithMoreThanOneWinner();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<CustomError>());
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(
        path,
        queryParameters: {
          'projection': 'years-with-multiple-winners',
        },
      )).thenThrow(DefaultException());

      final result = await datasource.getYearsWithMoreThanOneWinner();

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });

  // group('getStudiosWithTheMostWins', () {
  //   test('should return a list of StudioModel on success', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer(
  //       (_) async => {
  //         'studios': [
  //           {'name': 'Studio A', 'wins': 10},
  //           {'name': 'Studio B', 'wins': 5}
  //         ]
  //       },
  //     );

  //     final result = await datasource.getStudiosWithTheMostWins();

  //     expect(result.isRight(), true);
  //     expect(result.getOrElse(() => []), isA<List<StudioModel>>());
  //   });

  //   test('should return CustomError when the list is not found', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => {});

  //     final result = await datasource.getStudiosWithTheMostWins();

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l, (r) => null), isA<CustomError>());
  //   });

  //   test('should return CustomError in case of an exception', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenThrow(CustomException(error: CustomError(message: 'Error')));

  //     final result = await datasource.getStudiosWithTheMostWins();

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null), 'Error');
  //   });
  // });

  // group('getMoviesByYear', () {
  //   test('should return a list of MovieModel on success', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => [
  //               {'title': 'Movie 1', 'year': '1990', 'winner': true},
  //               {'title': 'Movie 2', 'year': '1990', 'winner': true}
  //             ]);

  //     final result = await datasource.getMoviesByYear('1990');

  //     expect(result.isRight(), true);
  //     expect(result.getOrElse(() => []), isA<List<MovieModel>>());
  //   });

  //   test('should return CustomError when no movies are found', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => []);

  //     final result = await datasource.getMoviesByYear('1990');

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null),
  //         'Movies not found in the year 1990');
  //   });

  //   test('should return CustomError in case of an exception', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenThrow(CustomException(error: CustomError(message: 'Error')));

  //     final result = await datasource.getMoviesByYear('1990');

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null), 'Error');
  //   });
  // });

  // group('getMoviesAwardsRange', () {
  //   test('should return ProducerIntervalDataModel on success', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => {
  //               'max': {'producer': 'Producer 1', 'interval': 10},
  //               'min': {'producer': 'Producer 2', 'interval': 1}
  //             });

  //     final result = await datasource.getMoviesAwardsRange();

  //     expect(result.isRight(), true);
  //     expect(result.getOrElse(() => null), isA<ProducerIntervalDataModel>());
  //   });

  //   test('should return CustomError when interval data is not found', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => {});

  //     final result = await datasource.getMoviesAwardsRange();

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null),
  //         'Movies awards range not found');
  //   });

  //   test('should return CustomError in case of an exception', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenThrow(CustomException(error: CustomError(message: 'Error')));

  //     final result = await datasource.getMoviesAwardsRange();

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null), 'Error');
  //   });
  // });

  // group('getMoviesByYearPagined', () {
  //   test('should return PaginedMoviesModel on success', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => {
  //               'movies': [
  //                 {'title': 'Movie 1', 'year': '1990', 'winner': true}
  //               ],
  //               'total': 1,
  //               'page': 1,
  //               'size': 1
  //             });

  //     final result = await datasource.getMoviesByYearPagined('1990',
  //         page: 1, size: 1, winner: true);

  //     expect(result.isRight(), true);
  //     expect(result.getOrElse(() => null), isA<PaginedMoviesModel>());
  //   });

  //   test('should return CustomError when movie list is not found', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenAnswer((_) async => {});

  //     final result = await datasource.getMoviesByYearPagined('1990',
  //         page: 1, size: 1, winner: true);

  //     expect(result.isLeft(), true);
  //     expect(
  //         result.fold((l) => l.message, (r) => null), 'Movie list not found');
  //   });

  //   test('should return CustomError in case of an exception', () async {
  //     when(mockHttpService.get(path,
  //             queryParameters: anyNamed('queryParameters')))
  //         .thenThrow(CustomException(error: CustomError(message: 'Error')));

  //     final result = await datasource.getMoviesByYearPagined('1990',
  //         page: 1, size: 1, winner: true);

  //     expect(result.isLeft(), true);
  //     expect(result.fold((l) => l.message, (r) => null), 'Error');
  //   });
  // });
}
