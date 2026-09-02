class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final int statusCode;
  final T? data;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 500,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
