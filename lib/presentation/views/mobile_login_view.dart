import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_current_user_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/presentation/widgets/build_login_illustration.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:quick_chat/utils/app_routes.dart';

class MobileLoginView extends StatefulWidget {
  const MobileLoginView({Key? key}) : super(key: key);

  @override
  State<MobileLoginView> createState() => _MobileLoginViewState();
}

class _MobileLoginViewState extends State<MobileLoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  StreamSubscription<UserModel?>? _userProfileListener;
  StreamSubscription<User?>? _authStateListener;
  User? _currentUser;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocListener<GetCurrentUserCubit, GetCurrentUserState>(
            listener: (context, state) {
              if (state is GetCurrentUserSuccess) {
                if (state.user != null) {
                  _currentUser = state.user;
                  context.read<GetUserProfileCubit>().fetchCurrentUserProfile(
                        _currentUser!.uid,
                      );
                }
              } else if (state is GetCurrentUserError) {
                Get.defaultDialog(title: 'Login', content: Text(state.message));
              }
            },
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is EmailLoginSuccess) {
                  context.read<GetCurrentUserCubit>().fetchCurrentUser();
                } else if (state is GoogleLoginSuccess) {
                  context.read<GetCurrentUserCubit>().fetchCurrentUser();
                } else if (state is EmailLoginError) {
                  Get.defaultDialog(
                    title: 'Login',
                    content: Text(state.message, textAlign: TextAlign.center),
                    textConfirm: 'Ok',
                    onConfirm: () => Get.back(),
                  );
                } else if (state is GoogleLoginError) {
                  if (state.message != 'cancel') {
                    Get.defaultDialog(
                      title: 'Login',
                      content: Text(state.message, textAlign: TextAlign.center),
                      textConfirm: 'Ok',
                      onConfirm: () => Get.back(),
                    );
                  }
                }
              },
              builder: (context, state) {
                return BlocListener<GetUserProfileCubit, GetUserProfileState>(
                  listener: (context, state) {
                    if (state is GetCurrentUserProfileSuccess) {
                      if (state.user != null) {
                        Get.offNamed(
                          kMobileHomeView,
                          arguments: _currentUser,
                        );
                      } else {
                        Get.offNamed(kMobileCreateProfileView);
                      }
                    } else if (state is GetCurrentUserProfileError) {
                      Get.defaultDialog(
                        title: 'Login',
                        content: Text(state.message),
                        textConfirm: 'Ok',
                        onConfirm: () => Get.back(),
                      );
                    }
                  },
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BuildLoginIllustration(
                            emailController: _emailController,
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () =>
                                  Get.toNamed(kMobileForgotPasswordView),
                              child: Text(
                                'Forgot password?',
                                textAlign: TextAlign.right,
                                style: context.textTheme.bodyText2!
                                    .copyWith(color: Colors.blue.shade900),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(double.maxFinite, 50),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().emailLogin(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                            child: const Text('Sign in'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kGoogleButtonSignInColor,
                              fixedSize: const Size(double.maxFinite, 50),
                            ),
                            onPressed: () async {
                              await context.read<AuthCubit>().googleLogin();
                            },
                            child: state is GoogleLoginLoading
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Image(
                                        width: 24,
                                        height: 24,
                                        image: AssetImage(
                                            'assets/images/google_icon.png'),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Or sign-in with google'),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(kMobileRegisterView),
                                  child: Text(
                                    "Sign up",
                                    style: context.textTheme.bodyText2!
                                        .copyWith(color: Colors.blue.shade900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    if (_userProfileListener != null) {
      _userProfileListener?.cancel();
    }
    if (_authStateListener != null) {
      _authStateListener?.cancel();
    }
    super.dispose();
  }
}
