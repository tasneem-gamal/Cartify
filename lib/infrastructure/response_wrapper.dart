import 'package:cartify/core/utils/json_util.dart';
import 'package:cartify/infrastructure/response_extra_model.dart';
import 'package:logger/logger.dart';

class ResponseWrapper<TResponse> {
  final String? type;
  final int? status;
  final TResponse? data;
  final dynamic body;
  final Map<String, dynamic>? header;
  final ResponseExtraModel? extra;

  ResponseWrapper({
    this.type,
    this.status,
    this.data,
    this.body,
    this.header,
    this.extra,
  });
  static final logger = Logger();
  bool get isSuccess => status == 200 || status == 201;
  factory ResponseWrapper.fromJson(
    Map<String, dynamic> json, {
    TResponse? responseData,
    Map<String, dynamic>? responseHeader,
    Map<String, dynamic>? responseOptionsHeader,
    int? statueCode,
    String dataKey = 'data',
    Map<String, dynamic>? extra,
  }) {
    //  logger.t('ResponseWrapper: ${json.toString()}');
    return ResponseWrapper<TResponse>(
      type: json['type'] ?? '',
      status: statueCode ?? 0,
      header: responseHeader,
      data: responseData,
      body: json[dataKey],
      extra: JsonUtil.deserialize(
        extra,
        (data) => ResponseExtraModel.fromJson(data),
      ),
    );
  }
}
