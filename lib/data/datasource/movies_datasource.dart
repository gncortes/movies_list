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
}
