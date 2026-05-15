import 'package:bloc/bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/auth/data/models/forget_password.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/data/models/usermodel.dart';
import 'package:bluebits_app/features/auth/data/repository/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authrepo}) : super(AuthInitial());
  final AuthRepo authrepo;
  Future<UserModel?> signup(UserData signupdata) async {
    try {
      emit(AuthLoading());
      final signupdataresult = await authrepo.signup(signupdata);
      print('------------------------------------------');
      print(signupdataresult);
      print('------------------------------------------');
      if (signupdataresult != null) {
        await CachHelper.setValue('Token', signupdataresult.token);
        print('success');
        emit(AuthSuccess(signupresult: signupdataresult));
        return signupdataresult;
      } else {
        emit(
          AuthFailed(
            message:
                'Signup returned no user data ${signupdataresult.toString()}',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      return null;
    }
  }

  Future<UserModel?> login(UserData logindata) async {
    try {
      emit(AuthLoading());
      final logindataresult = await authrepo.login(logindata);
      print('------------------------------------------');
      print(logindataresult);

      print('------------------------------------------');
      if (logindataresult != null) {
        await CachHelper.setValue('Token', logindataresult.token);

        emit(AuthSuccess(signupresult: logindataresult));
        return logindataresult;
      } else {
        emit(
          AuthFailed(
            message:
                'Login returned no user data ${logindataresult.toString()}',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      return null;
    }
  }

  Future<Password?> forgetpassword(String email) async {
    try {
      emit(AuthLoading());
      final forgetpasswordresult = await authrepo.forgetpassword(email);
      print('------------------------------------------');
      print(forgetpasswordresult?.message);

      print('------------------------------------------');
      if (forgetpasswordresult!.data != null) {
        emit(AuthForgetPassword(message: forgetpasswordresult.message));
        return forgetpasswordresult;
      } else {
        emit(
          AuthFailed(message: ' ${forgetpasswordresult.message.toString()}'),
        );
        return null;
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      return null;
    }
  }

  Future<Password?> resetpassword(String password, String token) async {
    try {
      emit(AuthLoading());
      final resetpasswordresult = await authrepo.resetpassword(password, token);
      print('------------------------------------------');
      print(resetpasswordresult?.message);

      print('------------------------------------------');
      if (resetpasswordresult != null && resetpasswordresult.data != null) {
        emit(AuthResetPassword(message: resetpasswordresult.message));
        return resetpasswordresult;
      } else {
        emit(
          AuthFailed(
            message:
                'Reset password returned no data ${resetpasswordresult!.message.toString()}',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      return null;
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      emit(AuthLoading());
      final token = await CachHelper.getValue('Token');
      print(token);
      if (token == null) {
        emit(Unauthenticated());
        return;
      }

      final userData = await authrepo.checkAuthStatus(token);
      print(userData);
      if (userData == 'Authenticated') {
        emit(Authenticated());
      } else if (userData == 'Unauthenticated') {
        emit(Unauthenticated());
      } else {
        emit(AuthFailed(message: 'Error checking authentication status'));
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }
}
