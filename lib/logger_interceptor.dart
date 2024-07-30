

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('REQUEST[${options.method}] => PATH: ${options.path} '
        '=> REQUEST HEADERS: ${options.headers} '
        '=> REQUEST BODY: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} '
        '=> RESPONSE HEADERS: ${response.headers} '
        '=> RESPONSE BODY: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} '
        '=> ERROR: ${err.message}');
    super.onError(err, handler);
  }
}
