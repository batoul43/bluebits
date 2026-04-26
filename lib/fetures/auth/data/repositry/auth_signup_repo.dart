import 'package:bluebits_app/fetures/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/fetures/auth/data/models/userdata.dart';
import 'package:bluebits_app/fetures/auth/data/models/usermodel.dart';

class AuthSignupRepo {
  final AuthApi authsignup;

  AuthSignupRepo({required this.authsignup});
  Future<UserModel?> signup(UserData signupdata) async {
    try {
      final signupdataresult = await authsignup.signup(signupdata);
      return UserModel.fromJson(signupdataresult as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}
