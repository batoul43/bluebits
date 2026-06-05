// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  final String email;
  final String password;
  final String? name;

  UserData({required this.email, required this.password, this.name});
  factory UserData.fromJson(Map json) {
    return UserData(
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }
}
