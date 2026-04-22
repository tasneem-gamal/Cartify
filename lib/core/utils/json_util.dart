class JsonUtil {
  static T? deserialize<T>(
    dynamic json,
    T Function(dynamic data) fromJsonFunc,
  ) {
    return json == null ? null : fromJsonFunc(json);
  }

  static List<T> deserializeList<T>(
    List<dynamic>? list,
    T Function(dynamic data) fromJsonFunc,
  ) {
    return list == null || list.isEmpty
        ? []
        : list.map((item) => fromJsonFunc(item)).toList();
  }
}
