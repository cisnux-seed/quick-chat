import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/usecases/update_user_profile.dart';

part 'update_user_profile_state.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileState> {
  UpdateUserProfileCubit(this.updateUserProfile)
      : super(UpdateUserProfileEmpty());

  final UpdateUserProfile updateUserProfile;
  Future<void> updateProfile({
    required UserModel user,
    String? imagePath,
  }) async {
    emit(UpdateUserProfileLoading());
    final result = await updateUserProfile.execute(
      user: user,
      imagePath: imagePath,
    );
    result.fold(
      (failure) => emit(UpdateUserProfileError(failure.message)),
      (success) => emit(UpdateUserProfileSuccess(success)),
    );
  }
}
