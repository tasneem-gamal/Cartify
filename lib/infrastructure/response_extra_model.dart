class ResponseExtraModel {
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  ResponseExtraModel({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory ResponseExtraModel.fromJson(Map<String, dynamic> json) {
    return ResponseExtraModel(
      totalCount: json['total'] ?? 0,
      pageNumber: json['page'] ?? 0,
      pageSize: json['size'] ?? 0,
      totalPages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': totalCount,
      'page': pageNumber,
      'size': pageSize,
      'pages': totalPages,
    };
  }
}