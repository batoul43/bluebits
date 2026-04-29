class ForgetPassword {
  final String message;
  final dynamic data;

  ForgetPassword({required this.message, required this.data});
  factory ForgetPassword.fromjson(Map json) {
    return ForgetPassword(message: json['message'], data: json['data']);
  }
  Map tojson() {
    return {'message': message, 'data': data};
  }
}
