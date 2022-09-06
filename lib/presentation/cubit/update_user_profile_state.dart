part of 'update_user_profile_cubit.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileEmpty extends UpdateUserProfileState {}

class UpdateUserProfileLoading extends UpdateUserProfileState {}

class UpdateUserProfileError extends UpdateUserProfileState {
  final String message;

  const UpdateUserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateUserProfileSuccess extends UpdateUserProfileState {
  final String message;

  const UpdateUserProfileSuccess(this.message);

  @override
  List<Object> get props => [message];
}
