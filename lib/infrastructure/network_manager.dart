import 'dart:io';

import 'package:cartify/infrastructure/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:cartify/core/managers/shared_pref_manager.dart';
import 'package:cartify/infrastructure/exceptions/exceptions_handler.dart';
import 'package:cartify/infrastructure/logger_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class NetworkManager {
  Future<ResponseWrapper<T?>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) fromJsonBuilder,
    bool addRefresh = true,
    Map<String, String>? headers,
    bool advId = false,
    bool isShowAlert = true,
  });

  Future<ResponseWrapper<T?>> post<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    void Function(int, int)? onSendProgressSendTotal,
    bool addRefresh = true,
    String? sessionToken,
    bool advId = false,
    bool isShowAlert = true,
  });

  Future<ResponseWrapper<T?>> put<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  });

  Future<ResponseWrapper<T?>> patch<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  });

  Future<ResponseWrapper<T?>> delete<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) fromJsonBuilder,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  });

  Future<void> download(
    String url,
    String savePath, {
    Map<String, String>? headers,
    bool addRefresh = true,
  });

  Future<bool> upload(
    String url,
    String filePath, {
    Map<String, String>? headers,
    bool addRefresh = true,
  });
}

class NetworkManagerImpl extends NetworkManager {
  final Dio _dioClient = Dio();
  final Logger _logger = Logger();

  NetworkManagerImpl() {
    _dioClient.interceptors.add(LoggerInterceptor());
    _dioClient.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        request: true,
      ),
    );
  }

  Future<ResponseWrapper<T>> _makeRequest<T>(
    Future<Response> requestMethod,
    String url, {
    required T Function(dynamic data) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    String dataKey = 'data',
    bool isShowAlert = true,
  }) async {
    try {
      final response = await requestMethod;

      final rawResponseData = response.data;

      if (rawResponseData is List<dynamic>) {
        final parsedBody = fromJson(rawResponseData);
        return ResponseWrapper<T>(
          status: response.statusCode,
          data: parsedBody,
          body: rawResponseData,
          header: response.headers.map,
        );
      }

      if (rawResponseData is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response type: ${rawResponseData.runtimeType}',
        );
      }

      final responseData = rawResponseData;

      if (responseData['success'] == false) {
        return ResponseWrapper<T>.fromJson(
          responseData,
          responseData: null,
          responseHeader: response.headers.map,
          responseOptionsHeader: response.requestOptions.headers,
          statueCode: response.statusCode,
          dataKey: dataKey,
          extra: responseData['error'],
        );
      }

      T? parsedBody;
      try {
        if (responseData.containsKey('data')) {
          parsedBody = fromJson(responseData['data']);
        } else {
          parsedBody = fromJson(responseData);
        }
      } catch (e) {
        parsedBody = fromJson(responseData);
      }

      return ResponseWrapper<T>.fromJson(
        responseData,
        responseData: parsedBody,
        responseHeader: response.headers.map,
        responseOptionsHeader: response.requestOptions.headers,
        statueCode: response.statusCode,
        dataKey: dataKey,
        extra: responseData['extra'] ?? responseData['pagination'],
      );
    } catch (e, stackTrace) {
      await ExceptionsHandler.handleException(
        e,
        stackTrace,
        isShowAlert: isShowAlert,
      );
      rethrow;
    }
  }

  @override
  Future<ResponseWrapper<T?>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) fromJsonBuilder,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
    Map<String, String>? headers,
  }) async {
    headers = await _getHeaders(headers, addRefresh, advId: advId);
    final method = _dioClient.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return _makeRequest(
      method,
      url,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJsonBuilder,
      isShowAlert: isShowAlert,
    );
  }

  @override
  Future<ResponseWrapper<T?>> post<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    void Function(int, int)? onSendProgressSendTotal,
    bool addRefresh = true,
    String? sessionToken,
    bool advId = false,
    bool isShowAlert = true,
  }) async {
    headers = await _getHeaders(
      headers,
      addRefresh,
      sessionToken: sessionToken,
      advId: advId,
    );
    final method = _dioClient.post(
      url,
      data: data,
      options: Options(headers: headers),
      onSendProgress: onSendProgressSendTotal,
    );
    return _makeRequest(
      method,
      url,
      data: data,
      headers: headers,
      fromJson: bodyBuilder,
      isShowAlert: isShowAlert,
    );
  }

  @override
  Future<ResponseWrapper<T?>> put<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  }) async {
    headers = await _getHeaders(headers, addRefresh, advId: advId);
    final method = _dioClient.put(
      url,
      data: data,
      options: Options(headers: headers),
    );
    return _makeRequest(
      method,
      url,
      data: data,
      headers: headers,
      fromJson: bodyBuilder,
      isShowAlert: isShowAlert,
    );
  }

  @override
  Future<ResponseWrapper<T?>> patch<T>(
    String url,
    dynamic data, {
    required T Function(dynamic data) bodyBuilder,
    Map<String, String>? headers,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  }) async {
    headers = await _getHeaders(headers, addRefresh, advId: advId);
    final method = _dioClient.patch(
      url,
      data: data,
      options: Options(headers: headers),
    );
    return _makeRequest(
      method,
      url,
      data: data,
      headers: headers,
      fromJson: bodyBuilder,
      isShowAlert: isShowAlert,
    );
  }

  @override
  Future<ResponseWrapper<T?>> delete<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) fromJsonBuilder,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    bool addRefresh = true,
    bool advId = false,
    bool isShowAlert = true,
  }) async {
    headers = await _getHeaders(headers, addRefresh, advId: advId);
    final method = _dioClient.delete(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      data: data,
    );
    return _makeRequest(
      method,
      url,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJsonBuilder,
      isShowAlert: isShowAlert,
    );
  }

  @override
  Future<void> download(
    String url,
    String savePath, {
    Map<String, String>? headers,
    bool addRefresh = true,
  }) async {
    headers = await _getHeaders(headers, addRefresh);
    await _dioClient.download(
      url,
      savePath,
      options: Options(headers: headers),
    );
  }

  @override
  Future<bool> upload(
    String url,
    String filePath, {
    Map<String, String>? headers,
    bool addRefresh = true,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      headers = await _getHeaders(headers, addRefresh);
      final response = await _dioClient.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      return response.statusCode != null &&
          response.statusCode! >= HttpStatus.ok &&
          response.statusCode! < HttpStatus.multipleChoices;
    } catch (e) {
      _logger.e('Upload Error: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders(
    Map<String, String>? headers,
    bool addRefresh, {
    String? sessionToken,
    bool advId = false,
  }) async {
    final token =
        sessionToken ?? await SharedPreferencesManager.getData(key: '');
    final refresh = await SharedPreferencesManager.getData(key: '');

    final defaultHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'accept-language': 'en',
      if (token != null) 'Authorization': 'Bearer $token',
      if (addRefresh && refresh != null) 'x-refresh-token': 'Bearer $refresh',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }
}
