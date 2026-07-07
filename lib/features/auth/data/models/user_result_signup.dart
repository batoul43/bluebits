// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserResultSignup {
  final String email;

  final String? message;
  UserResultSignup({required this.email, this.message});
  factory UserResultSignup.fromJson(Map json) {
    return UserResultSignup(
      email: json['data']['user']['email'],
      message: json['message'],
    );
  }
  Map<String, String?> toJson() {
    return {'email': email, 'message': message};
  }
}
