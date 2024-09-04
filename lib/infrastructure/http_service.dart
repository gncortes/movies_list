import 'dart:io';

import 'package:dio/dio.dart';

import '../domain/failures/custom_http_exceptions.dart';

abstract class HttpServiceInterface {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool v2BaseUrl = false,
  });
}

class HttpServiceImplementation implements HttpServiceInterface {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      baseUrl: 'https://tools.outsera.com/backend-java/api/',
    ),
  );

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool v2BaseUrl = false,
  }) {
    queryParameters?.removeWhere((key, value) => value == null);

    return _handleRequest(
      () => dio.get(
        path,
        queryParameters: queryParameters,
      ),
    );
  }

  Future _handleRequest(Future<Response> Function() request) async {
    try {
      var response = await request();

      return response.data;
    } on SocketException catch (_) {
      throw NoInternetConnectionException();
    } on DioException catch (error) {
      if (error.response?.data != null) throw BadResponse(error.response?.data);

      throw DefaultException();
    } on BadResponse {
      rethrow;
    } catch (error) {
      throw DefaultException();
    }
  }
}
