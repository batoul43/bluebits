// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final bool isSuccess;
  final String message;
  final int statusCode;
  final String? token;
  final String? name;
  final String? email;

  UserModel({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.token,
    this.name,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // نقوم بتخزين الـ data أولاً للتحقق منها بمرونة
    final data = json['data'];

    return UserModel(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,

      // استخدام ?.[ ] يضمن عدم حدوث خطأ إذا كانت data تساوي null
      token: data?['token'],
      name: data?['user']?['name'],
      email: data?['user']?['email'],
    );
  }
}
