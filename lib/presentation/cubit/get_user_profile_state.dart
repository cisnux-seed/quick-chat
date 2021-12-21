part of 'get_user_profile_cubit.dart';

abstract class GetUserProfileState extends Equatable {
  const GetUserProfileState();

  @override
  List<Object?> get props => [];
}

class GetUserProfileStateInitial extends GetUserProfileState {}

class GetCurrentUserProfileLoading extends GetUserProfileState {}

class GetCurrentUserProfileError extends GetUserProfileState {
  final String message;

  const GetCurrentUserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class GetCurrentUserProfileSuccess extends GetUserProfileState {
  final UserModel? user;

  const GetCurrentUserProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class GetOtherUserProfileLoading extends GetUserProfileState {}

class GetOtherUserProfileError extends GetUserProfileState {
  final String message;

  const GetOtherUserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class GetOtherUserProfileSuccess extends GetUserProfileState {
  final UserModel? user;

  const GetOtherUserProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
