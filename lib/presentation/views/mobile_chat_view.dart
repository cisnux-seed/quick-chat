import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/data/models/image_message_model.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/data/models/text_message_model.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/presentation/cubit/data_picker_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_messages_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/presentation/cubit/send_message_cubit.dart';
import 'package:quick_chat/presentation/widgets/build_avatar.dart';
import 'package:quick_chat/presentation/widgets/image_message_bubble.dart';
import 'package:quick_chat/presentation/widgets/text_message_bubble.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'package:quick_chat/utils/format_date.dart';

class MobileChatView extends StatefulWidget {
  const MobileChatView({Key? key}) : super(key: key);

  @override
  State<MobileChatView> createState() => _MobileChatViewState();
}

class _MobileChatViewState extends State<MobileChatView> {
  late TextEditingController _messageController;
  late RoomModel _room;
  late String _otherUserId;
  late UserModel _currentUserProfile;

  @override
  void initState() {
    super.initState();
    _room = Get.arguments['room'];
    _otherUserId = Get.arguments['otherUserId'];
    _currentUserProfile = Get.arguments['currentUserProfile'];
    context.read<GetUserProfileCubit>().fetchOtherUserProfile(_otherUserId);
    context.read<GetMessagesCubit>().getUserMessages(_room.id!);
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DataPickerCubit, DataPickerState>(
          listener: (context, state) {
            if (state is ImagePickerSuccess) {
              context.read<SendMessageCubit>().sendMessages(
                    message: ImageMessageModel(
                      authorId: _currentUserProfile.id,
                      createdAt: Timestamp.now(),
                      type: 'image',
                      roomId: _room.id!,
                    ),
                    room: _room.copyWith(
                      latestMessage: 'send an picture',
                      updatedAt: Timestamp.now(),
                    ),
                    imagePath: state.imagePath,
                  );
            }
          },
        ),
        BlocListener<SendMessageCubit, SendMessageState>(
          listener: (context, state) {
            if (state is SendMessageError) {
              Get.defaultDialog(
                title: 'Send message',
                content: Text(state.message),
              );
            }
          },
        ),
      ],
      child: BlocConsumer<GetUserProfileCubit, GetUserProfileState>(
          listener: (context, state) {},
          builder: (context, getOtherUserProfile) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                leadingWidth: 28,
                title: (getOtherUserProfile is GetOtherUserProfileSuccess &&
                        getOtherUserProfile.user != null)
                    ? Row(
                        children: [
                          buildAvatar(getOtherUserProfile.user!.profilePict),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getOtherUserProfile.user!.username),
                              Text(
                                getOtherUserProfile.user!.isOnline
                                    ? "Online"
                                    : formatDate(
                                        getOtherUserProfile.user!.lastSeen
                                            .toDate(),
                                      ),
                                style: context.textTheme.bodyText2!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                ),
              ),
              body: BlocBuilder<GetMessagesCubit, GetMessagesState>(
                  builder: (context, getMessages) {
                if (getMessages is GetMessagesSuccess) {
                  return Stack(
                    children: [
                      if (getMessages.messages.isNotEmpty)
                        ListView.builder(
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                index != getMessages.messages.length - 1
                                    ? 8
                                    : 16,
                                10,
                                index != 0 ? 0 : 20 * 4,
                              ),
                              child: (getMessages.messages[index]
                                      is TextMessageModel)
                                  ? TextBubbleMessage(
                                      message: getMessages.messages[index],
                                      isFromCurrentUser: _currentUserProfile
                                              .id ==
                                          getMessages.messages[index].authorId,
                                    )
                                  : ImageBubbleMessage(
                                      message: getMessages.messages[index],
                                      isFromCurrentUser: _currentUserProfile
                                              .id ==
                                          getMessages.messages[index].authorId,
                                      onTap: () => Get.toNamed(
                                        kMobileImageView,
                                        arguments:
                                            getMessages.messages[index].uri,
                                      ),
                                    ),
                            );
                          },
                          itemCount: getMessages.messages.length,
                          reverse: true,
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                          ),
                          width: context.width,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.surface,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Write a message...',
                                      prefixIcon: IconButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          await context
                                              .read<DataPickerCubit>()
                                              .pickImages();
                                        },
                                        icon: Transform.rotate(
                                          angle: 130,
                                          child: const Icon(
                                            Icons.attachment_rounded,
                                            color: kIconKeyboardChatColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    maxLines: 6,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 1,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (_messageController.text.isNotEmpty &&
                                      _messageController.text
                                          .trim()
                                          .isNotEmpty &&
                                      getOtherUserProfile
                                          is GetOtherUserProfileSuccess &&
                                      getOtherUserProfile.user != null) {
                                    await context
                                        .read<SendMessageCubit>()
                                        .sendMessages(
                                          message: TextMessageModel(
                                            createdAt: Timestamp.now(),
                                            text: _messageController.text,
                                            authorId: _currentUserProfile.id,
                                            type: 'text',
                                            roomId: _room.id!,
                                          ),
                                          room: _room.copyWith(
                                            profilePict: <String?>[
                                              getOtherUserProfile
                                                  .user!.profilePict,
                                              _currentUserProfile.profilePict,
                                            ],
                                            latestMessage:
                                                _messageController.text,
                                            updatedAt: Timestamp.now(),
                                          ),
                                        );
                                    _messageController.clear();
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: kIconKeyboardChatColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
            );
          }),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
