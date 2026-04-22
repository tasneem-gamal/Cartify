import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor implements Interceptor {
  final logger = Logger();

  LoggerInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.i('  Dio Error!');
    logger.i('  Response Error: ${err.response?.data}');
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
