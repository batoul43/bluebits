part of 'authcubit_cubit.dart';

@immutable
abstract class AuthcubitState {}

class AuthcubitInitial extends AuthcubitState {}

class AuthcubitLoading extends AuthcubitState {}

class AuthcubitSuccess extends AuthcubitState {
  final UserModel signupresult;

  AuthcubitSuccess({required this.signupresult});
}

class AuthcubitFailed extends AuthcubitState {
  final String message;

  AuthcubitFailed({required this.message});
}
