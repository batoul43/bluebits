// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bluebits_app/fetures/auth/data/models/userdata.dart';

class UserModel {
  final String token;
  final UserData? user;
  UserModel({required this.token, this.user});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['data']['token'],
      user: json['data']['user'] != null
          ? UserData.fromJson(json['data']['user'])
          : null,
    );
  }
}
