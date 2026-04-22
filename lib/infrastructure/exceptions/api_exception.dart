

import 'package:cartify/infrastructure/response_wrapper.dart';

class APIException implements Exception {
  const APIException(this.message);
  final String message;
}

class ErrorResponseException extends APIException {
  ErrorResponseException() : super('Invalid API key');
}

class NoInternetConnectionException extends APIException {
  NoInternetConnectionException() : super('No Internet connection');
}

class UnauthorizedException extends APIException {
  final ResponseWrapper responseWrapper;
  UnauthorizedException({required this.responseWrapper})
    : super('Error Unauthorized Exception');
}

class FailureResponseException extends APIException {
  final ResponseWrapper responseWrapper;
  FailureResponseException({required this.responseWrapper})
    : super('Error Response Exception');
}

class TooManyRequestException extends APIException {
  final ResponseWrapper responseWrapper;
  TooManyRequestException({required this.responseWrapper})
    : super('Too Many Request Exception');
}

class UnknownException extends APIException {
  UnknownException() : super('Some error occurred');
}
