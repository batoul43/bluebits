class Password {
  final String message;
  final dynamic data;

  Password({required this.message, required this.data});
  factory Password.fromjson(Map json) {
    return Password(message: json['message'], data: json['data']);
  }
  Map tojson() {
    return {'message': message, 'data': data};
  }
}
