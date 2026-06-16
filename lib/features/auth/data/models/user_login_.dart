// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserLogin {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});
  factory UserLogin.fromJson(Map json) {
    return UserLogin(email: json['email'], password: json['password']);
  }
  Map<String, String?> toJson() {
    return {'email': email, 'password': password};
  }
}
