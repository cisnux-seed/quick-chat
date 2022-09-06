part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthEmpty extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterError extends AuthState {
  final String message;

  const RegisterError(this.message);
}

class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailLoginLoading extends AuthState {}

class EmailLoginError extends AuthState {
  final String message;

  const EmailLoginError(this.message);

  @override
  List<Object> get props => [message];
}

class EmailLoginSuccess extends AuthState {
  final String message;

  const EmailLoginSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class GoogleLoginLoading extends AuthState {}

class GoogleLoginSuccess extends AuthState {
  final String message;

  const GoogleLoginSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class GoogleLoginError extends AuthState {
  final String message;

  const GoogleLoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordError extends AuthState {
  final String message;

  const ResetPasswordError(this.message);

  @override
  List<Object> get props => [message];
}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CreateUserProfileLoading extends AuthState {}

class CreateUserProfileError extends AuthState {
  final String message;

  const CreateUserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateUserProfileSuccess extends AuthState {
  final String message;

  const CreateUserProfileSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SignOutLoading extends AuthState {}

class SignOutError extends AuthState {
  final String message;

  const SignOutError(this.message);

  @override
  List<Object> get props => [message];
}

class SignOutSuccess extends AuthState {
  final String message;

  const SignOutSuccess(this.message);

  @override
  List<Object> get props => [message];
}
