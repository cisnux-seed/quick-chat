import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quick_chat/data/models/image_message_model.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/data/models/text_message_model.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/utils/exceptions.dart';
import 'dart:io';

abstract class RemoteDataSource {
  Stream<List<UserModel>> getUsers(String keyword, UserModel currentUser);
  Stream<List<dynamic>> getMessages(String roomId);
  Future<String> createUser({required UserModel user, String? imagePath});
  Future<String> sendMessage({
    dynamic message,
    String? imagePath,
    required RoomModel room,
  });
  Future<String> updateUser({required UserModel user, String? imagePath});
  Stream<UserModel?> getUser(String currentUserId);
  Stream<List<RoomModel?>> getRooms(String currentUserId);
  Future<RoomModel> createRoom(RoomModel room);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseStorage,
  });

  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  @override
  Future<String> createUser({
    required UserModel user,
    String? imagePath,
  }) async {
    try {
      if (imagePath != null) {
        final reference = firebaseStorage.ref(imagePath);
        final file = File(imagePath);
        await reference.putFile(file);
        final url = await reference.getDownloadURL();
        await firestore.collection('users').doc(user.id).set(user
            .copyWith(
              profilePict: url,
            )
            .toJson());
      } else {
        await firestore.collection('users').doc(user.id).set(user.toJson());
      }
      return 'success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<List<UserModel>> getUsers(String keyword, UserModel currentUser) {
    try {
      return firestore
          .collection('users')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.fold<List<UserModel>>([], (prev, doc) {
                if (currentUser.id == doc.id) return prev;
                final data = doc.data();
                data['id'] = doc.id;
                return [...prev, UserModel.fromJson(data)];
              }))
          .map((users) => (keyword.isNotEmpty)
              ? users
                  .where((user) =>
                      user.email
                          .toLowerCase()
                          .contains(keyword.toLowerCase()) ||
                      user.username
                          .toLowerCase()
                          .contains(keyword.toLowerCase()))
                  .toList()
              : []);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<UserModel?> getUser(String currentUserId) {
    try {
      return firestore
          .collection('users')
          .doc(currentUserId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.data() != null) {
          return UserModel.fromJson(snapshot.data()!);
        } else {
          return null;
        }
      });
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateUser({
    required UserModel user,
    String? imagePath,
  }) async {
    try {
      if (imagePath != null) {
        final reference = firebaseStorage.ref(imagePath);
        final file = File(imagePath);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        await firestore.collection('users').doc(user.id).update(user
            .copyWith(
              profilePict: uri,
            )
            .toJson());
      } else {
        await firestore.collection('users').doc(user.id).update(user.toJson());
      }
      return 'success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<RoomModel> createRoom(RoomModel room) async {
    try {
      final result = await firestore
          .collection('rooms')
          .where('userIds',
              whereIn: [room.userIds, room.userIds.reversed.toList()])
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) {
              return null;
            }
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return RoomModel.fromJson(data);
            }).toList();
          })
          .first;

      if (result == null) {
        final data = await firestore.collection('rooms').add(room.toJson());
        final response = await data.get();
        final Map<String, dynamic>? json = {'id': data.id}
          ..addAll(response.data()!);

        return RoomModel.fromJson(json!);
      } else {
        final response = result.first;
        return response;
      }
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> sendMessage({
    dynamic message,
    String? imagePath,
    required RoomModel room,
  }) async {
    try {
      await firestore
          .collection('rooms')
          .doc(message.roomId)
          .update(room.toJson());
      if (message is TextMessageModel) {
        await firestore
            .collection('rooms')
            .doc(message.roomId)
            .collection('messages')
            .add(message.toJson());
      } else if (message is ImageMessageModel && imagePath != null) {
        final reference = firebaseStorage.ref(imagePath);
        final file = File(imagePath);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        await firestore
            .collection('rooms')
            .doc(message.roomId)
            .collection('messages')
            .add(message.copyWith(uri: uri).toJson());
      }
      return 'success';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<List<dynamic>> getMessages(String roomId) {
    try {
      return firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return [];
        }
        return snapshot.docs.map((doc) {
          if (doc.data()['type'] == 'text') {
            return TextMessageModel.fromJson(doc.data());
          } else {
            return ImageMessageModel.fromJson(doc.data());
          }
        }).toList();
      });
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<List<RoomModel?>> getRooms(String currentUserId) {
    try {
      final result = firestore
          .collection('rooms')
          .orderBy('latestMessage')
          .where('latestMessage', isNull: false)
          .where('userIds', arrayContainsAny: [currentUserId])
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) {
              return <RoomModel>[];
            }
            return snapshot.docs.map((doc) {
              final data = doc.data();
              if (data.isNotEmpty) {
                data['id'] = doc.id;
                return RoomModel.fromJson(data);
              }
            }).toList();
          });
      return result;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
