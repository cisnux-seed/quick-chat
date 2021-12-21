import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/domain/usecases/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'get_current_user_state.dart';

class GetCurrentUserCubit extends Cubit<GetCurrentUserState> {
  GetCurrentUserCubit(this.getCurrentUser) : super(GetCurrentUserEmpty());

  final Auth getCurrentUser;

  void fetchCurrentUser() {
    emit(GetCurrentUserLoading());
    final result = getCurrentUser.currentUser();

    result.fold(
      (failure) => emit(GetCurrentUserError(failure.message)),
      (success) => emit(GetCurrentUserSuccess(success)),
    );
  }
}
