import 'custom_error.dart';

abstract class CustomException implements Exception {
  final CustomError error;

  const CustomException({
    required this.error,
  });
}

class NoInternetConnectionException extends CustomException {
  NoInternetConnectionException()
      : super(error: const CustomError(message: 'Sem conexão com a internet'));

  @override
  String toString() {
    return error.toString();
  }
}

class BadResponse extends CustomException {
  final dynamic data;

  BadResponse(this.data) : super(error: _buildCustomError(data));

  static CustomError _buildCustomError(dynamic data) {
    String message = '';

    if (data == null) {
      message = 'Aconteceu um erro inesperado';
    } else {
      message = data.toString();
    }

    return CustomError(
      message: message,
    );
  }

  @override
  String toString() => error.message;

  static String formatErrors(List<String> errors) {
    if (errors.isEmpty) {
      return '';
    }

    return errors.join('\n');
  }
}

class DefaultException extends CustomException {
  DefaultException()
      : super(
            error: const CustomError(message: 'Aconteceu um erro inesperado'));

  @override
  String toString() {
    return 'Aconteceu um erro inesperado';
  }
}
