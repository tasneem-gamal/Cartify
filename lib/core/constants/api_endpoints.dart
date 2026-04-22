import 'app_constants.dart';

class ApiEndPoints {
  ApiEndPoints._();
  static String get baseUrl => AppConstants.baseUrl;

  static const defaultPageSize = 10;
  static const defaultPage = 1;

  // Auth End Points
  static String get preSignedUrl => '$baseUrl/generate_presigned_url';
  static String get products => '$baseUrl/products';
  static String get categories => '$baseUrl/categories';
}
