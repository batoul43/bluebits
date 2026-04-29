part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel signupresult;

  AuthSuccess({required this.signupresult});
}

class AuthForgetPassword extends AuthState {
  final String message;

  AuthForgetPassword({required this.message});
}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed({required this.message});
}
