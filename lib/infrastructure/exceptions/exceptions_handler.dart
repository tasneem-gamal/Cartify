import 'dart:io';
import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/core/enums/snackbar_message_type.dart';
import 'package:cartify/core/managers/toast_manager.dart';
import 'package:cartify/infrastructure/exceptions/api_exception.dart';
import 'package:cartify/infrastructure/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

class ExceptionsHandler {
  static String getUserFacingMessage(
    Object error, {
    String fallback = 'something went wrong',
  }) {
    final backendMessage = _extractBackendErrorMessage(error);
    return sanitizeUserFacingMessage(backendMessage, fallback: fallback);
  }

  static String sanitizeUserFacingMessage(
    String? message, {
    String fallback = 'something went wrong',
  }) {
    String value = (message ?? '').trim();
    if (value.startsWith('Exception: ')) {
      value = value.substring('Exception: '.length).trim();
    }

    if (value.isEmpty) return fallback;

    final normalized = value.toLowerCase();
    if (normalized.contains('dioexception') ||
        normalized.contains('bad response') ||
        normalized.contains('requestoptions.validatestatus') ||
        normalized.contains('socketexception') ||
        normalized.contains('clientexception') ||
        normalized.contains('xmlhttprequest error') ||
        normalized.contains("type '") ||
        normalized.contains('stack trace')) {
      return fallback;
    }

    return _resolveErrorMessage(value);
  }

  static Future<void> handleException(
    Object e,
    StackTrace stackTrace, {
    bool isShowAlert = true,
  }) async {
    final logger = Logger();

    /// check connect network
    bool checkNetwork = await checkConnectNetwork(e, stackTrace);
    if (!checkNetwork) return;

    /// then filter error response
    if (e is DioException) {
      ResponseWrapper responseWrapperValue = ResponseWrapper.fromJson(
        e.response?.data,
        statueCode: e.response?.statusCode,
        responseData: e.response?.data,
        responseHeader: e.response?.headers.map,
      );

      Map<String, dynamic>? error = e.response?.data;

      if ((error?.isNotEmpty ?? false) && checkNetwork) {
        String message;
        if (error!['errors'] is List) {
          message = (error['errors'] as List)
              .map((e) => e['error'])
              .toSet()
              .join('\n');
        } else if (error['message'] != null) {
          message = error['message'];
        } else if (error['error'] != null) {
          message = error['error']['message'];
        } else {
          message = error['message'];
        }
        if (isShowAlert) _showErrorAlert(_resolveErrorMessage(message));
      }

      if (e.response?.statusCode == HttpStatus.tooManyRequests) {
        throw TooManyRequestException(responseWrapper: responseWrapperValue);
      } else {
        throw FailureResponseException(responseWrapper: responseWrapperValue);
      }
    } else {
      logger.f(
        "Error [unknown] in ResponseWrapper",
        error: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  static Future<bool> checkConnectNetwork(
    Object e,
    StackTrace stackTrace,
  ) async {
    final logger = Logger();
    ToastManager.dismiss();
    logger.f(
      "Error in ResponseWrapper",
      error: e.toString(),
      stackTrace: stackTrace,
    );

    bool result =
        await InternetConnectionChecker.createInstance().hasConnection;
    if (!result) {
      final navigatorState = AppGlobals.navigatorKey.currentState;
      final overlayContext = navigatorState?.overlay?.context;
      final context = overlayContext ?? AppGlobals.navigatorKey.currentContext;

      if (context != null && context.mounted) {
        ToastManager.show(
          context: context,
          message: 'No internet connection',
          type: SnackBarMessageType.error,
          duration: const Duration(seconds: 5),
        );
      }
    } else {
      logger.i("clear toasts");
      ToastManager.dismiss();
    }
    return result;
  }

  static void _showErrorAlert(String error) {
    final navigatorState = AppGlobals.navigatorKey.currentState;
    final overlayContext = navigatorState?.overlay?.context;
    final context = overlayContext ?? AppGlobals.navigatorKey.currentContext;

    if (context != null && context.mounted) {
      ToastManager.show(
        context: context,
        message: error,
        type: SnackBarMessageType.error,
        duration: const Duration(seconds: 4),
      );
    }
  }

  static String _resolveErrorMessage(String rawMessage) {
    switch (rawMessage) {
      case 'errors.order.minimumAmount':
        return 'Minimum order amount has not been reached. Please add more items to continue.';
      default:
        return rawMessage;
    }
  }

  static String? _extractBackendErrorMessage(Object error) {
    if (error is FailureResponseException) {
      final fromData = _extractMessageFromPayload(error.responseWrapper.data);
      if (fromData != null) return fromData;

      final fromBody = _extractMessageFromPayload(error.responseWrapper.body);
      if (fromBody != null) return fromBody;

      return null;
    }

    if (error is DioException) {
      final fromData = _extractMessageFromPayload(error.response?.data);
      if (fromData != null) return fromData;
      return error.message;
    }

    if (error is APIException) {
      return error.message;
    }

    return error.toString();
  }

  static String? _extractMessageFromPayload(dynamic payload) {
    if (payload == null) return null;

    if (payload is String) {
      final text = payload.trim();
      return text.isEmpty ? null : text;
    }

    if (payload is Map<String, dynamic>) {
      final error = payload['error'];
      if (error is Map<String, dynamic>) {
        final nested = _extractMessageFromPayload(error);
        if (nested != null) return nested;
      }

      final message = payload['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errors = payload['errors'];
      if (errors is List && errors.isNotEmpty) {
        final messages = errors
            .map((item) {
              if (item is Map<String, dynamic>) {
                final nestedMessage =
                    _extractMessageFromPayload(item) ??
                    (item['error']?.toString()) ??
                    (item['message']?.toString());
                return nestedMessage?.trim() ?? '';
              }
              return item.toString().trim();
            })
            .where((item) => item.isNotEmpty)
            .toSet()
            .join('\n');

        if (messages.isNotEmpty) {
          return messages;
        }
      }
    }

    return null;
  }
}
