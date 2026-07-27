class Password {
  final String message;
  final dynamic data;
  final bool isSuccess;

  Password({
    required this.message,
    required this.data,
    required this.isSuccess,
  });
  factory Password.fromjson(Map json) {
    return Password(
      message: json['message'],
      data: json['data'],
      isSuccess: json['isSuccess'],
    );
  }
  Map tojson() {
    return {'message': message, 'data': data, 'isSuccess': isSuccess};
  }
}
