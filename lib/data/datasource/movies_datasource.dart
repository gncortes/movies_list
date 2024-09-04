import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../domain/failures/custom_error.dart';
import '../../domain/failures/custom_http_exceptions.dart';
import '../../infrastructure/http_service.dart';
import '../models/year_model.dart';

abstract class IMoviesDatasource {
  Future<Either<CustomError, List<YearModel>>> getYearsWithMoreThanOneWinner();
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
}
