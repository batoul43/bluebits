import 'dart:async';

import 'package:bluebits_app/features/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/features/auth/data/models/user_login_.dart';
import 'package:bluebits_app/features/auth/data/models/user_result_signup.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/data/models/usermodel.dart';

import '../models/forget_password.dart';

class AuthRepo {
  final AuthApi authApi;

  AuthRepo({required this.authApi});
  Future<UserResultSignup?> signup(UserData signupdata) async {
    try {
      final signupdataresult = await authApi.signup(signupdata);
      print('------------------------------------------');
      print('repo:${signupdataresult}');
      print('------------------------------------------');

      final data = UserResultSignup.fromJson(signupdataresult);
      print('repodata:$data');
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> login(UserLogin logindata) async {
    try {
      final loginDataResult = await authApi.login(logindata);
      return UserModel.fromJson(loginDataResult);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Password?> forgetpassword(String email) async {
    try {
      final forgetpasswordresult = await authApi.ForgetPassword(email);
      print('------------------------------------------');
      print(forgetpasswordresult);
      print('------------------------------------------');
      return Password.fromjson(forgetpasswordresult);
    } catch (e) {
      return null;
    }
  }

  Future<Password?> resetpassword(String password, String token) async {
    try {
      final resetpasswordresult = await authApi.ResetPassword(password, token);
      return Password.fromjson(resetpasswordresult);
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

  Future<dynamic> logout(String token) async {
    try {
      final logout = await authApi.logout(token);
      return logout;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> resendVerification(String email) async {
    try {
      final resendVerification = await authApi.resendVerification(email);
      return resendVerification;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
