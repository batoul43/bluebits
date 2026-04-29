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
}
