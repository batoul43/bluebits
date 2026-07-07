part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthSuccessLogin extends AuthState {
  final UserModel Loginresult;

  AuthSuccessLogin({required this.Loginresult});
}

class AuthSuccessSignup extends AuthState {
  final UserResultSignup signupresult;

  AuthSuccessSignup({required this.signupresult});
}

class AuthForgetPassword extends AuthState {
  final String message;

  AuthForgetPassword({required this.message});
}

class AuthResetPassword extends AuthState {
  final String message;

  AuthResetPassword({required this.message});
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailed extends AuthState {
  final String message;

  AuthLogoutFailed({required this.message});
}

class AuthresendVerification extends AuthState {
  final String message;

  AuthresendVerification({required this.message});
}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed({required this.message});
}
