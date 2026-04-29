// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String token;
  final String name;
  final String email;

  UserModel({required this.token, required this.name, required this.email});
  factory UserModel.fromJson(Map json) {
    return UserModel(
      token: json['data']['token'],
      name: json['data']['user']['name'],
      email: json['data']['user']['email'],
    );
  }
}
