import 'package:flutter/material.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/presentation/cubit/create_room_cubit.dart';
import 'package:quick_chat/presentation/cubit/search_account_cubit.dart';
import 'package:quick_chat/presentation/widgets/build_avatar.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:get/get.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_chat/utils/format_date.dart';
import 'package:quick_chat/utils/get_specific_data.dart';

class MobileSearchView extends StatefulWidget {
  const MobileSearchView({Key? key}) : super(key: key);

  @override
  State<MobileSearchView> createState() => _MobileSearchViewState();
}

class _MobileSearchViewState extends State<MobileSearchView> {
  late TextEditingController _searchController;
  UserModel? _currentUserProfile;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currentUserProfile = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRoomCubit, CreateRoomState>(
      listener: (context, state) {
        if (state is CreateRoomSuccess) {
          context.read<SearchAccountCubit>().setStateToEmpty();
          FocusScope.of(context).unfocus();
          Get.offNamed(
            kMobileChatView,
            arguments: {
              'room': state.room,
              'otherUserId':
                  getSpecificData(state.room.userIds, _currentUserProfile!.id),
              'currentUserProfile': _currentUserProfile,
            },
          );
        } else if (state is CreateRoomError) {
          Get.defaultDialog(
            title: 'Create Room',
            content: Text(state.message, textAlign: TextAlign.center),
            textConfirm: 'Ok',
            onConfirm: () => Get.back(),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 40,
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              _searchController.clear();
              context.read<SearchAccountCubit>().setStateToEmpty();
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kIconKeyboardChatColor,
            ),
          ),
          title: TextField(
            controller: _searchController,
            onChanged: (keyword) {
              if (_currentUserProfile != null) {
                context.read<SearchAccountCubit>().fetchUsers(
                      _searchController.text,
                      _currentUserProfile!,
                    );
              }
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
          ),
        ),
        body: BlocConsumer<SearchAccountCubit, SearchAccountState>(
          listener: (context, state) {
            if (state is SearchAccountError) {
              Get.defaultDialog(
                title: 'Search account',
                content: Text(state.message, textAlign: TextAlign.center),
                textConfirm: 'Ok',
                onConfirm: () => Get.back(),
              );
            }
          },
          builder: (context, state) {
            if (state is SearchAccountSuccess) {
              if (state.users.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return ListTile(
                      onTap: () async {
                        if (_currentUserProfile != null) {
                          await context.read<CreateRoomCubit>().createChatRoom(
                                RoomModel(
                                  usernames: [
                                    state.users[index].username,
                                    _currentUserProfile!.username,
                                  ],
                                  userIds: [
                                    _currentUserProfile!.id,
                                    state.users[index].id
                                  ],
                                ),
                              );
                        }
                      },
                      leading: buildAvatar(state.users[index].profilePict),
                      title: Text(state.users[index].username),
                      trailing: Text(
                        formatDate(
                          state.users[index].lastSeen.toDate(),
                        ),
                        style: context.textTheme.caption,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: state.users.length,
                );
              } else {
                return Center(
                  child: Text(
                    'No result',
                    style: context.textTheme.headline6,
                  ),
                );
              }
            } else if (state is SearchAccountLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchAccountInitial) {
              return Center(
                child: Text(
                  'Search friends',
                  style: context.textTheme.headline6,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
