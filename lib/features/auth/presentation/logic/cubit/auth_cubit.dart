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
      print(logindataresult?.token);

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

  Future<ForgetPassword?> forgetpassword(String email) async {
    try {
      emit(AuthLoading());
      final forgetpasswordresult = await authrepo.forgetpassword(email);
      print('------------------------------------------');
      print(forgetpasswordresult?.message);

      print('------------------------------------------');
      if (forgetpasswordresult != null) {
        emit(AuthForgetPassword(message: forgetpasswordresult.message));
        return forgetpasswordresult;
      } else {
        emit(
          AuthFailed(
            message:
                'Forget password returned no data ${forgetpasswordresult.toString()}',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      return null;
    }
  }
}
