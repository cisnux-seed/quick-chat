import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/usecases/get_user_profile.dart';

part 'get_user_profile_state.dart';

class GetUserProfileCubit extends Cubit<GetUserProfileState> {
  GetUserProfileCubit(this.getUserProfile)
      : super(GetUserProfileStateInitial());

  final GetUserProfile getUserProfile;
  StreamSubscription<UserModel?>? _userProfileListener;

  void fetchCurrentUserProfile(String id) {
    emit(GetCurrentUserProfileLoading());
    final result = getUserProfile.execute(id);
    result.fold(
      (failure) => emit(GetCurrentUserProfileError(failure.message)),
      (success) => _userProfileListener = success.listen(
          (userProfile) => emit(GetCurrentUserProfileSuccess(userProfile))),
    );
  }

  void fetchOtherUserProfile(String id) {
    emit(GetOtherUserProfileLoading());
    final result = getUserProfile.execute(id);
    result.fold(
      (failure) => emit(GetOtherUserProfileError(failure.message)),
      (success) => _userProfileListener = success.listen(
          (userProfile) => emit(GetOtherUserProfileSuccess(userProfile))),
    );
  }

  @override
  Future<void> close() async {
    if (_userProfileListener != null) {
      await _userProfileListener?.cancel();
    }
    return super.close();
  }
}
