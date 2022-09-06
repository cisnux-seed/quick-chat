import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_chat_rooms_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/presentation/cubit/update_user_profile_cubit.dart';
import 'package:quick_chat/presentation/widgets/build_avatar.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'package:quick_chat/utils/format_date.dart';
import 'package:quick_chat/utils/get_specific_data.dart';

class MobileHomeView extends StatefulWidget {
  const MobileHomeView({Key? key}) : super(key: key);

  @override
  State<MobileHomeView> createState() => _MobileHomeViewState();
}

class _MobileHomeViewState extends State<MobileHomeView>
    with WidgetsBindingObserver, RouteAware {
  UserModel? _currentUserProfile;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Get.arguments;
    if (_currentUser != null) {
      context.read<GetChatRoomsCubit>().fetchChatRooms(_currentUser!.uid);
      context
          .read<GetUserProfileCubit>()
          .fetchCurrentUserProfile(_currentUser!.uid);
    }
    WidgetsBinding.instance.addObserver(this);
    if (context.read<GetUserProfileCubit>().state
        is GetCurrentUserProfileSuccess) {
      if (_currentUserProfile != null) {
        Future.microtask(
          () => context.read<UpdateUserProfileCubit>().updateProfile(
                user: _currentUserProfile!.copyWith(
                  isOnline: true,
                  lastSeen: Timestamp.now(),
                ),
              ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    kRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    if (_currentUser != null) {
      context.read<GetChatRoomsCubit>().fetchChatRooms(_currentUser!.uid);
      context
          .read<GetUserProfileCubit>()
          .fetchCurrentUserProfile(_currentUser!.uid);
    }
    super.didPopNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (context.read<GetUserProfileCubit>().state
        is GetCurrentUserProfileSuccess) {
      if (state == AppLifecycleState.resumed) {
        context.read<UpdateUserProfileCubit>().updateProfile(
              user: _currentUserProfile!.copyWith(
                isOnline: true,
                lastSeen: Timestamp.now(),
              ),
            );
      } else {
        context.read<UpdateUserProfileCubit>().updateProfile(
              user: _currentUserProfile!.copyWith(
                isOnline: false,
                lastSeen: Timestamp.now(),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is SignOutSuccess) {
              Get.offAllNamed(kMobileLoginView);
            } else if (state is SignOutError) {
              Get.defaultDialog(
                title: 'Log out',
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
              if (state.user != null) {
                _currentUserProfile = state.user;
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
        BlocListener<UpdateUserProfileCubit, UpdateUserProfileState>(
          listener: (context, state) async {
            if (state is UpdateUserProfileSuccess) {
              await context.read<AuthCubit>().signOut();
            } else if (state is UpdateUserProfileError) {
              Get.defaultDialog(
                title: 'Update Profile',
                content: Text(state.message, textAlign: TextAlign.center),
                textConfirm: 'Ok',
                onConfirm: () => Get.back(),
              );
            }
          },
        ),
        BlocListener<GetChatRoomsCubit, GetChatRoomsState>(
          listener: (context, state) {
            if (state is GetChatRoomsError) {
              Get.defaultDialog(
                title: 'Get Chats Room',
                content: Text(state.message),
              );
            } else if (state is GetChatRoomsError) {
              Get.defaultDialog(
                title: 'Latest Messages',
                content: Text(state.message, textAlign: TextAlign.center),
                textConfirm: 'Ok',
                onConfirm: () => Get.back(),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Chat'),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (_currentUserProfile != null) {
                  Get.toNamed(
                    kMobileSearchView,
                    arguments: _currentUserProfile,
                  );
                }
              },
              icon: const Icon(
                Icons.search_rounded,
              ),
            )
          ],
        ),
        drawer: BlocBuilder<GetUserProfileCubit, GetUserProfileState>(
          builder: (context, state) {
            if (state is GetCurrentUserProfileSuccess && state.user != null) {
              return Drawer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: UserAccountsDrawerHeader(
                        currentAccountPicture:
                            buildAvatar(state.user!.profilePict),
                        accountName: Text(
                          state.user!.username,
                          style: context.textTheme.bodyText1!.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        accountEmail: Text(
                          state.user!.email,
                          style: context.textTheme.bodyText1!.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: context.theme.colorScheme.onBackground,
                      ),
                      title: Text(
                        'Settings',
                        style: context.textTheme.bodyText1!.copyWith(
                          color: context.theme.colorScheme.onBackground,
                        ),
                      ),
                      onTap: () => Get.back(),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        color: context.theme.colorScheme.onBackground,
                      ),
                      title: Text(
                        'Sign out',
                        style: context.textTheme.bodyText1!.copyWith(
                          color: context.theme.colorScheme.onBackground,
                        ),
                      ),
                      onTap: () async {
                        if (_currentUserProfile != null) {
                          await context
                              .read<UpdateUserProfileCubit>()
                              .updateProfile(
                                user: _currentUserProfile!.copyWith(
                                    isOnline: false, lastSeen: Timestamp.now()),
                              );
                        }
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        body: BlocBuilder<GetChatRoomsCubit, GetChatRoomsState>(
          builder: (context, rooms) {
            if (rooms is GetChatRoomsSuccess &&
                rooms.roomModels.isNotEmpty &&
                _currentUserProfile != null) {
              return ListView.separated(
                itemBuilder: (_, index) => ListTile(
                  onTap: () => Get.toNamed(kMobileChatView, arguments: {
                    'currentUserProfile': _currentUserProfile,
                    'otherUserId': getSpecificData(
                      rooms.roomModels[index]!.userIds,
                      _currentUserProfile!.id,
                    ),
                    'room': rooms.roomModels[index],
                  }),
                  leading: buildAvatar(
                    _getUriProfilePict(
                      rooms.roomModels[index]?.profilePict,
                      _currentUserProfile?.profilePict,
                    ),
                  ),
                  title: Text(
                    getSpecificData(
                      rooms.roomModels[index]!.usernames,
                      _currentUserProfile!.username,
                    ),
                  ),
                  subtitle: Text(
                    rooms.roomModels[index]!.latestMessage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    formatDate(
                      rooms.roomModels[index]!.updatedAt!.toDate(),
                    ),
                    style: context.textTheme.caption,
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: rooms.roomModels.length,
              );
            } else if (rooms is GetChatRoomsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Let's find some friends"));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String? _getUriProfilePict(
    List<String?>? profilePict,
    String? currentUserProfilePict,
  ) =>
      profilePict?.where((uri) => uri != currentUserProfilePict).first;
}
