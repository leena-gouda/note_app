part of 'signup_cubit.dart';

sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final UserModel? user;
  SignUpSuccess({this.user});
}

final class SignUpError extends SignUpState {
  final String? message;

  SignUpError({this.message});
}