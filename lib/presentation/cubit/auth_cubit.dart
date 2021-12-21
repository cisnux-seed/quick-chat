import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/usecases/auth.dart';
import 'package:quick_chat/domain/usecases/create_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.auth,
    required this.createUserProfile,
  }) : super(AuthEmpty());

  final Auth auth;
  final CreateUserProfile createUserProfile;
  StreamSubscription<User?>? _authStateListener;

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    final result = await auth.createAccount(email, password);
    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (success) => emit(RegisterSuccess(success)),
    );
  }

  Future<void> emailLogin(String email, String password) async {
    emit(EmailLoginLoading());
    final result = await auth.signIn(email, password);
    result.fold(
      (failure) => emit(EmailLoginError(failure.message)),
      (success) => emit(EmailLoginSuccess(success)),
    );
  }

  Future<void> googleLogin() async {
    emit(GoogleLoginLoading());
    final result = await auth.googleSignIn();
    result.fold(
      (failure) => emit(GoogleLoginError(failure.message)),
      (success) => emit(GoogleLoginSuccess(success)),
    );
    emit(AuthEmpty());
  }

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());
    final result = await auth.resetPassword(email);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.message)),
      (success) => emit(ResetPasswordSuccess(success)),
    );
  }

  Future<void> createProfile({
    required UserModel user,
    String? imagePath,
  }) async {
    emit(CreateUserProfileLoading());
    final result = await createUserProfile.execute(
      user: user,
      imagePath: imagePath,
    );
    result.fold(
      (failure) => emit(CreateUserProfileError(failure.message)),
      (success) {
        emit(CreateUserProfileSuccess(success));
      },
    );
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    final result = await auth.signOut();
    result.fold(
      (failure) => emit(SignOutError(failure.message)),
      (success) => emit(SignOutSuccess(success)),
    );
  }

  @override
  Future<void> close() async {
    if (_authStateListener != null) {
      await _authStateListener?.cancel();
    }
    return super.close();
  }
}
