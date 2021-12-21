import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/cubit/data_picker_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_chat/presentation/cubit/get_current_user_cubit.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'dart:io';

class MobileCreateProfileView extends StatefulWidget {
  const MobileCreateProfileView({Key? key}) : super(key: key);

  @override
  State<MobileCreateProfileView> createState() =>
      _MobileCreateProfileViewState();
}

class _MobileCreateProfileViewState extends State<MobileCreateProfileView> {
  late TextEditingController _usernameController;
  User? _currentUser;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    Future.microtask(
        () => context.read<GetCurrentUserCubit>().fetchCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<GetCurrentUserCubit, GetCurrentUserState>(
          listener: (context, state) {
            if (state is GetCurrentUserSuccess) {
              if (state.user != null) {
                _currentUser = state.user!;
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
          child: BlocConsumer<DataPickerCubit, DataPickerState>(
            listener: (context, state) {
              if (state is ImagePickerError) {
                Get.defaultDialog(
                  title: 'Select picture',
                  content: Text(state.message, textAlign: TextAlign.center),
                  textConfirm: 'Ok',
                  onConfirm: () => Get.back(),
                );
              }
            },
            builder: (context, dataPicker) =>
                BlocConsumer<AuthCubit, AuthState>(
              listener: (_, state) {
                if (state is CreateUserProfileSuccess) {
                  context.read<DataPickerCubit>().setStateToEmpty();
                  Get.offAllNamed(kMobileHomeView, arguments: _currentUser);
                } else if (state is CreateUserProfileError) {
                  Get.defaultDialog(
                    title: 'Create Profile',
                    content: Text(state.message, textAlign: TextAlign.center),
                    textConfirm: 'Ok',
                    onConfirm: () => Get.back(),
                  );
                }
              },
              builder: (context, auth) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 72, bottom: 16),
                      height: 96,
                      width: 96,
                      child: dataPicker is ImagePickerSuccess &&
                              dataPicker.imagePath != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(
                                File(dataPicker.imagePath!),
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                await context
                                    .read<DataPickerCubit>()
                                    .pickImages();
                              },
                              icon: Icon(
                                Icons.add_a_photo_rounded,
                                color: context.theme.colorScheme.primary,
                                size: 42,
                              ),
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        border: Border(
                          bottom: BorderSide(
                            color: context.theme.colorScheme.primary,
                          ),
                          left: BorderSide(
                            color: context.theme.colorScheme.primary,
                          ),
                          right: BorderSide(
                            color: context.theme.colorScheme.primary,
                          ),
                          top: BorderSide(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Profile picture',
                      style: context.theme.textTheme.headline5!.copyWith(
                        color: context.theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Select your profile picture and\nenter your username",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyText1!.copyWith(
                        color: context.theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 320,
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _usernameController,
                        validator: (value) {
                          return value != null && value.isNotEmpty
                              ? null
                              : 'Please enter your username';
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.primary,
                            ),
                          ),
                          hintText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(320, 50),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (dataPicker is DataPickerEmpty) {
                            if (_currentUser != null) {
                              await context.read<AuthCubit>().createProfile(
                                    user: UserModel(
                                      isOnline: true,
                                      id: _currentUser!.uid,
                                      username: _usernameController.text,
                                      email: _currentUser!.email!,
                                      lastSeen: Timestamp.now(),
                                    ),
                                  );
                            }
                          } else if (dataPicker is ImagePickerSuccess) {
                            if (_currentUser != null) {
                              await context.read<AuthCubit>().createProfile(
                                    user: UserModel(
                                      isOnline: true,
                                      id: _currentUser!.uid,
                                      username: _usernameController.text,
                                      email: _currentUser!.email!,
                                      lastSeen: Timestamp.now(),
                                    ),
                                    imagePath: dataPicker.imagePath,
                                  );
                            }
                          }
                        }
                      },
                      child: const Text('Create'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
