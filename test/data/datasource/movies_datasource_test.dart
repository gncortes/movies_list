import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_list/data/datasource/movies_datasource.dart';
import 'package:movies_list/data/models/models.dart';
import 'package:movies_list/domain/failures/custom_error.dart';
import 'package:movies_list/domain/failures/failures.dart';
import 'package:movies_list/infrastructure/infrastructure.dart';
import 'package:mockito/annotations.dart';

import 'movies_datasource_test.mocks.dart';

@GenerateMocks([IHttpService])
void main() {
  late IMoviesDatasource datasource;
  late IHttpService mockHttpService;

  const path = 'movies';

  setUp(() {
    mockHttpService = MockIHttpService();
    datasource = MoviesDatasource(mockHttpService);
  });

  group('getYearsWithMoreThanOneWinner', () {
    final queryParameters = {'projection': 'years-with-multiple-winners'};
    test('should return a list of YearModel on success', () async {
      when(
        mockHttpService.get(path, queryParameters: queryParameters),
      ).thenAnswer(
        (_) async => {
          'years': [
            {"year": 9999, "winnerCount": 99},
            {"year": 9999, "winnerCount": 99}
          ]
        },
      );

      final result = await datasource.getYearsWithMoreThanOneWinner();

      verify(
        mockHttpService.get(path, queryParameters: queryParameters),
      ).called(1);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<YearModel>>());
    });

    test('should return CustomError when the list is not found', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer((_) async => {});

      final result = await datasource.getYearsWithMoreThanOneWinner();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<CustomError>());
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenThrow(DefaultException());

      final result = await datasource.getYearsWithMoreThanOneWinner();

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });

  group('getStudiosWithTheMostWins', () {
    final queryParameters = {'projection': 'studios-with-win-count'};
    test('should return a list of StudioModel on success', () async {
      when(mockHttpService.get(
        path,
        queryParameters: queryParameters,
      )).thenAnswer(
        (_) async => {
          "studios": [
            {"name": "Studio Name", "winCount": 9},
            {"name": "Studio Name", "winCount": 9}
          ]
        },
      );

      final result = await datasource.getStudiosWithTheMostWins();

      verify(
        mockHttpService.get(
          path,
          queryParameters: queryParameters,
        ),
      ).called(1);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<StudioModel>>());
    });

    test('should return CustomError when the list is not found', () async {
      when(mockHttpService.get(
        path,
        queryParameters: queryParameters,
      )).thenAnswer((_) async => {});

      final result = await datasource.getStudiosWithTheMostWins();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<CustomError>());
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(
        path,
        queryParameters: queryParameters,
      )).thenThrow(DefaultException());

      final result = await datasource.getStudiosWithTheMostWins();

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });

  group('getMoviesByYear', () {
    final queryParameters = {'winner': 'true', 'year': '1990'};
    test('should return a list of MovieModel on success', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer(
        (_) async => [
          {
            "id": 99,
            "year": 1990,
            "title": "Movie Title",
            "studios": ["Studio Name"],
            "producers": [" Producer Name "],
            "winner": true
          }
        ],
      );

      final result = await datasource.getMoviesByYear('1990');

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<MovieModel>>());
    });

    test('should return CustomError when no movies are found', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer((_) async => []);

      final result = await datasource.getMoviesByYear('1990');

      expect(result.isLeft(), true);
      expect(result.fold((l) => l.message, (r) => null),
          'Filmes não encontrados no ano de 1990');
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenThrow(
        DefaultException(),
      );

      final result = await datasource.getMoviesByYear('1990');

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });

  group('getMoviesAwardsRange', () {
    final queryParameters = {
      'projection': 'max-min-win-interval-for-producers'
    };
    test('should return ProducerIntervalDataModel on success', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer(
        (_) async => {
          "min": [
            {
              "producer": "Producer Name",
              "interval": 9,
              "previousWin": 2018,
              "followingWin": 2019
            }
          ],
          "max": [
            {
              "producer": "Producer Name",
              "interval": 99,
              "previousWin": 1900,
              "followingWin": 1999
            }
          ]
        },
      );

      final result = await datasource.getMoviesAwardsRange();

      expect(result.isRight(), true);
    });

    test('should return CustomError when interval data is not found', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer((_) async => {});

      final result = await datasource.getMoviesAwardsRange();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l.message, (r) => null),
          'Intervalo de filmes não encontrado');
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(path,
              queryParameters: anyNamed('queryParameters')))
          .thenThrow(
        DefaultException(),
      );

      final result = await datasource.getMoviesAwardsRange();

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });

  group('getMoviesByYearPagined', () {
    final queryParameters = {
      'year': '1990',
      'page': 1,
      'size': 1,
      'winner': true,
    };
    test('should return PaginedMoviesModel on success', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer(
        (_) async => {
          "content": [
            {
              "id": 999,
              "year": 1900,
              "title": "Movie Title",
              "studios": ["Studio Name"],
              "producers": ["Producer Name"],
              "winner": true
            },
            {
              "id": 999,
              "year": 1900,
              "title": "Movie Title",
              "studios": ["Studio Name", "Studio Name"],
              "producers": ["Producer Name"],
              "winner": false
            }
          ],
          "pageable": {
            "sort": {"sorted": false, "unsorted": true},
            "pageSize": 00,
            "pageNumber": 0,
            "offset": 0,
            "paged": true,
            "unpaged": false
          },
          "totalElements": 999,
          "last": false,
          "totalPages": 99,
          "first": true,
          "sort": {"sorted": false, "unsorted": true},
          "number": 0,
          "numberOfElements": 99,
          "size": 99
        },
      );

      final result = await datasource.getMoviesByYearPagined(
        '1990',
        page: 1,
        size: 1,
        winner: true,
      );

      expect(result.isRight(), true);
    });

    test('should return CustomError when movie list is not found', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenAnswer((_) async => {});

      final result = await datasource.getMoviesByYearPagined('1990',
          page: 1, size: 1, winner: true);

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Lista de filmes não encontrada',
      );
    });

    test('should return CustomError in case of an exception', () async {
      when(mockHttpService.get(path, queryParameters: queryParameters))
          .thenThrow(
        DefaultException(),
      );

      final result = await datasource.getMoviesByYearPagined('1990',
          page: 1, size: 1, winner: true);

      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        'Aconteceu um erro inesperado',
      );
    });
  });
}
