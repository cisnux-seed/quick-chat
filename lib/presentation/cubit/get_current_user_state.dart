part of 'get_current_user_cubit.dart';

abstract class GetCurrentUserState extends Equatable {
  const GetCurrentUserState();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEmpty extends GetCurrentUserState {}

class GetCurrentUserLoading extends GetCurrentUserState {}

class GetCurrentUserError extends GetCurrentUserState {
  final String message;

  const GetCurrentUserError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetCurrentUserSuccess extends GetCurrentUserState {
  final User? user;

  const GetCurrentUserSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
