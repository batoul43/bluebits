import 'dart:async';

import 'package:bluebits_app/features/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/data/models/usermodel.dart';

import '../models/forget_password.dart';

class AuthRepo {
  final AuthApi authApi;

  AuthRepo({required this.authApi});
  Future<UserModel?> signup(UserData signupdata) async {
    try {
      final signupdataresult = await authApi.signup(signupdata);
      // print('------------------------------------------');
      // print('repo:${signupdataresult}');
      // print('------------------------------------------');

      final data = UserModel.fromJson(signupdataresult);
      print('repodata:$data');
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> login(UserData logindata) async {
    try {
      final loginDataResult = await authApi.login(logindata);
      return UserModel.fromJson(loginDataResult);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<ForgetPassword?> forgetpassword(String email) async {
    try {
      final forgetpassword = await authApi.ForgetPassword(email);
      return ForgetPassword.fromjson(forgetpassword);
    } catch (e) {
      return null;
    }
  }

  Future<String> checkAuthStatus(String token) async {
    try {
      final response = await authApi.checkAuthStatus(token);
      print('------------------------------------------');
      print(response.statusCode);
      print('------------------------------------------');
      if (response != null && response.statusCode == 200) {
        return 'Authenticated';
      } else if (response != null && response.statusCode == 401) {
        return 'Unauthenticated';
      } else {
        return 'errorUnauthenticated';
      }
    } catch (e) {
      print(e.toString());
      return 'errorUnauthenticated';
    }
  }
}
