import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/data/models/image_message_model.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/data/models/text_message_model.dart';
import 'package:quick_chat/data/models/user_model.dart';

String? imagePath = 'awesome.png';

final userModel = UserModel(
  username: "fajra",
  id: '1',
  email: "fajra@gmail.com",
  lastSeen: Timestamp.now(),
  isOnline: false,
);

final currentUserModel = UserModel(
  username: "eren jaeger",
  id: '3',
  email: "eren@gmail.com",
  lastSeen: Timestamp.now(),
  isOnline: false,
);

final otherUserModel = UserModel(
  username: "cisnux",
  id: '2',
  profilePict: 'http://cisnux',
  email: "cisnux@gmail.com",
  lastSeen: Timestamp.now(),
  isOnline: true,
);

const roomModel = RoomModel(
  id: '1',
  usernames: ['username1', 'username2'],
  userIds: ['1', '2'],
);

const otherRoomModel = RoomModel(
  id: '2',
  usernames: ['username5', 'username6'],
  userIds: ['10', '12'],
);

final chatRoomModel = RoomModel(
  id: '3',
  usernames: const ['username1', 'username2'],
  userIds: const ['1', '3'],
  latestMessage: 'halo semua',
  updatedAt: Timestamp.now(),
  profilePict: const ['https://eldian', 'https://marley'],
);

final textMessage = TextMessageModel(
  text: 'hai',
  authorId: '2',
  createdAt: Timestamp.now(),
  type: 'text',
  roomId: '1',
);

final imageMessage = ImageMessageModel(
  uri: 'https://eldian.com',
  authorId: '2',
  createdAt: Timestamp.now(),
  type: 'image',
  roomId: '2',
);

final blankImageMessage = ImageMessageModel(
  authorId: '2',
  createdAt: Timestamp.now(),
  type: 'image',
  roomId: '2',
);

final chatRoomMessage = ImageMessageModel(
  uri: 'https://eldian.com',
  authorId: '2',
  createdAt: Timestamp.now(),
  type: 'image',
  roomId: '3',
);

const emailKeyword = 'fajra@gmail.com';
const usernameKeyword = 'cisnux';
const notFoundKeyword = '';

const email = 'fajra@gmail.com';
const password = 'fajra123';
