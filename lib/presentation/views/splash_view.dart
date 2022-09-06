import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_chat/presentation/cubit/get_current_user_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<GetCurrentUserCubit>().fetchCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetCurrentUserCubit, GetCurrentUserState>(
          listener: (context, state) async {
            if (state is GetCurrentUserSuccess) {
              if (state.user != null) {
                _currentUser = state.user;
                await Future.delayed(
                  const Duration(seconds: 3),
                  () => context
                      .read<GetUserProfileCubit>()
                      .fetchCurrentUserProfile(state.user!.uid),
                );
              } else {
                await Future.delayed(
                  const Duration(seconds: 3),
                  () => Get.offNamed(kMobileLoginView),
                );
              }
            } else if (state is GetCurrentUserError) {
              Get.defaultDialog(
                title: 'Auth State',
                content: Text(state.message, textAlign: TextAlign.center),
                textConfirm: 'Ok',
                onConfirm: () => Get.back(),
              );
            }
          },
        ),
        BlocListener<GetUserProfileCubit, GetUserProfileState>(
          listener: (context, state) {
            if (state is GetCurrentUserProfileSuccess) {
              if (state.user != null && _currentUser != null) {
                Get.offNamed(kMobileHomeView, arguments: _currentUser);
              } else {
                Get.offNamed(kMobileCreateProfileView);
              }
            } else if (state is GetCurrentUserProfileError) {
              Get.defaultDialog(
                title: 'User Profile',
                content: Text(state.message, textAlign: TextAlign.center),
                textConfirm: 'Ok',
                onConfirm: () => Get.back(),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: Image.asset('assets/icons/splash_icon.png'),
              ),
              const SizedBox(height: 16),
              Text('Quick Chat', style: context.textTheme.headline4),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
