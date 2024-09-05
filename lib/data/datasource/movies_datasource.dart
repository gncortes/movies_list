import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../domain/failures/custom_error.dart';
import '../../domain/failures/custom_http_exceptions.dart';
import '../../infrastructure/http_service.dart';
import '../models/models.dart';

abstract class IMoviesDatasource {
  Future<Either<CustomError, List<YearModel>>> getYearsWithMoreThanOneWinner();

  Future<Either<CustomError, List<StudioModel>>> getStudiosWithTheMostWins();

  Future<Either<CustomError, List<MovieModel>>> getMoviesByYear(String year);

  Future<Either<CustomError, ProducerIntervalDataModel>> getMoviesAwardsRange();

  Future<Either<CustomError, PaginedMoviesModel>> getMoviesByYearPagined(
    String year, {
    required int page,
    required int size,
    required bool winner,
  });
}

class MoviesDatasource implements IMoviesDatasource {
  final HttpServiceInterface _httpService;

  MoviesDatasource(this._httpService);

  final path = 'movies';

  @override
  Future<Either<CustomError, List<YearModel>>>
      getYearsWithMoreThanOneWinner() async {
    try {
      final response = await _httpService.get(
        path,
        queryParameters: {
          'projection': 'years-with-multiple-winners',
        },
      );

      if (response['years'] is List) {
        return Right((response['years'] as List)
            .map((e) => YearModel.fromJson(e))
            .toList());
      }

      return const Left(CustomError(
        message: 'Lista de filmes não encontrada',
      ));
    } on CustomException catch (error) {
      return Left(error.error);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

      return const Left(CustomError());
    }
  }

  @override
  Future<Either<CustomError, List<StudioModel>>>
      getStudiosWithTheMostWins() async {
    try {
      final response = await _httpService.get(
        path,
        queryParameters: {
          'projection': 'studios-with-win-count',
        },
      );

      if (response['studios'] is List) {
        return Right((response['studios'] as List)
            .map((e) => StudioModel.fromJson(e))
            .toList());
      }

      return const Left(CustomError(
        message: 'Lista de Estudios não encontrada',
      ));
    } on CustomException catch (error) {
      return Left(error.error);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

      return const Left(CustomError());
    }
  }

  @override
  Future<Either<CustomError, List<MovieModel>>> getMoviesByYear(
      String year) async {
    try {
      final response = await _httpService.get(
        path,
        queryParameters: {'winner': 'true', 'year': year},
      );

      if (response is List && response.isNotEmpty) {
        return Right(
          (response).map((e) => MovieModel.fromJson(e)).toList(),
        );
      }

      return Left(
        CustomError(message: 'Filmes não encontrados no ano de $year'),
      );
    } on CustomException catch (error) {
      return Left(error.error);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

      return const Left(CustomError());
    }
  }

  @override
  Future<Either<CustomError, ProducerIntervalDataModel>>
      getMoviesAwardsRange() async {
    try {
      final response = await _httpService.get(path, queryParameters: {
        'projection': 'max-min-win-interval-for-producers'
      });

      if (response is Map<String, dynamic>) {
        return Right(ProducerIntervalDataModel.fromJson(response));
      }

      return const Left(
        CustomError(message: 'Intervalo de filmes não encontrado'),
      );
    } on CustomException catch (error) {
      return Left(error.error);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

      return const Left(CustomError());
    }
  }

  @override
  Future<Either<CustomError, PaginedMoviesModel>> getMoviesByYearPagined(
    String year, {
    required int page,
    required int size,
    required bool winner,
  }) async {
    try {
      final response = await _httpService.get(
        path,
        queryParameters: {
          'winner': winner,
          'year': year,
          'page': page,
          'size': size,
        },
      );

      await Future.delayed(const Duration(seconds: 3));

      if (response is Map<String, dynamic>) {
        return Right(PaginedMoviesModel.fromJson(json));
      }

      return const Left(CustomError(
        message: 'Lista de filmes não encontrada',
      ));
    } on CustomException catch (error) {
      return Left(error.error);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

      return const Left(CustomError());
    }
  }
}

final json = {
  "content": [
    {
      "id": 197,
      "year": 2018,
      "title": "Holmes & Watson",
      "studios": ["Columbia Pictures"],
      "producers": [
        "Adam McKay",
        "Clayton Townsend",
        "Jimmy Miller",
        "Will Ferrell"
      ],
      "winner": true
    },
    {
      "id": 198,
      "year": 2019,
      "title": "Once Upon a Time in Hollywood",
      "studios": ["Columbia Pictures"],
      "producers": ["David Heyman", "Shannon McIntosh", "Quentin Tarantino"],
      "winner": true
    },
    {
      "id": 199,
      "year": 2020,
      "title": "Parasite",
      "studios": ["CJ Entertainment"],
      "producers": ["Kwak Sin-ae", "Bong Joon-ho"],
      "winner": true
    },
    {
      "id": 200,
      "year": 2018,
      "title": "A Star is Born",
      "studios": ["Warner Bros."],
      "producers": ["Bradley Cooper", "Bill Gerber", "Lynette Howell Taylor"],
      "winner": false
    },
    {
      "id": 201,
      "year": 2021,
      "title": "Dune",
      "studios": ["Legendary Pictures"],
      "producers": ["Mary Parent", "Denis Villeneuve", "Cale Boyter"],
      "winner": true
    },
    {
      "id": 202,
      "year": 2017,
      "title": "The Shape of Water",
      "studios": ["Fox Searchlight Pictures"],
      "producers": ["Guillermo del Toro", "J. Miles Dale"],
      "winner": true
    },
    {
      "id": 203,
      "year": 2016,
      "title": "La La Land",
      "studios": ["Lionsgate"],
      "producers": ["Fred Berger", "Jordan Horowitz", "Marc Platt"],
      "winner": false
    },
    {
      "id": 204,
      "year": 2019,
      "title": "Joker",
      "studios": ["Warner Bros."],
      "producers": [
        "Todd Phillips",
        "Bradley Cooper",
        "Emma Tillinger Koskoff"
      ],
      "winner": false
    },
    {
      "id": 205,
      "year": 2020,
      "title": "1917",
      "studios": ["Universal Pictures"],
      "producers": ["Sam Mendes", "Pippa Harris", "Jayne-Ann Tenggren"],
      "winner": false
    },
    {
      "id": 206,
      "year": 2021,
      "title": "No Time to Die",
      "studios": ["MGM"],
      "producers": ["Michael G. Wilson", "Barbara Broccoli"],
      "winner": false
    }
  ],
  "pageable": {
    "sort": {"unsorted": true, "sorted": false, "empty": true},
    "offset": 0,
    "pageSize": 10,
    "pageNumber": 0,
    "unpaged": false,
    "paged": true
  },
  "last": false,
  "totalPages": 1,
  "totalElements": 10,
  "size": 10,
  "number": 0,
  "sort": {"unsorted": true, "sorted": false, "empty": true},
  "first": true,
  "numberOfElements": 10,
  "empty": false
};
