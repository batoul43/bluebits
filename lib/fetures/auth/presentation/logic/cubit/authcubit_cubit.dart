import 'package:bloc/bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/fetures/auth/data/models/userdata.dart';
import 'package:bluebits_app/fetures/auth/data/models/usermodel.dart';
import 'package:bluebits_app/fetures/auth/data/repositry/auth_signup_repo.dart';
import 'package:meta/meta.dart';

part 'authcubit_state.dart';

class AuthcubitCubit extends Cubit<AuthcubitState> {
  AuthcubitCubit({required this.authsignuprepo}) : super(AuthcubitInitial());
  final AuthSignupRepo authsignuprepo;
  Future<UserModel?> signup(UserData signupdata) async {
    try {
      emit(AuthcubitInitial());
      final signupdataresult = await authsignuprepo.signup(signupdata);
      if (signupdataresult != null) {
        CachHelper.setvalue(signupdataresult.token, 'Token');
        emit(AuthcubitSuccess(signupresult: signupdataresult));
        return signupdataresult;
      } else {
        emit(
          AuthcubitFailed(
            message:
                'Signup returned no user data ${signupdataresult.toString()}',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(AuthcubitFailed(message: e.toString()));
      return null;
    }
  }
}
