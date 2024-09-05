import '../../../domain/entities/movie_entity.dart';
import '../../../domain/failures/custom_error.dart';

abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesSuccessState extends MoviesState {
  final List<MovieEntity> movies;
  final int totalPages;

  MoviesSuccessState({required this.movies, required this.totalPages});
}

class MoviesErrorState extends MoviesState {
  final CustomError error;

  MoviesErrorState({required this.error});
}
