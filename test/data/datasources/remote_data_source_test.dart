import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_chat/data/datasources/remote_data_source.dart';
import 'package:quick_chat/data/models/room_model.dart';

import '../../dummy/dummy_objects.dart';

void main() {
  late RemoteDataSourceImpl dataSource;
  late FakeFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockFirestorage;

  setUpAll(() async {
    mockFirestore = FakeFirebaseFirestore();
    mockFirestorage = MockFirebaseStorage();
    dataSource = RemoteDataSourceImpl(
      firestore: mockFirestore,
      firebaseStorage: mockFirestorage,
    );
  });

  test(
    'should return usermodel when fetch user profile is successful',
    () async {
      // arrange
      await mockFirestore.collection('users').doc('1').set(userModel.toJson());
      // act
      final result = dataSource.getUser('1');
      // assert
      expect(await result.first, userModel);
    },
  );

  test(
    'should return string success when create user profile is successful',
    () async {
      // arrange
      // act
      final result = await dataSource.createUser(user: userModel);
      // assert
      expect(result, 'success');
    },
  );

  test(
    'should return string success when update user profile is successful',
    () async {
      // arrange
      // act
      final result = await dataSource.updateUser(user: userModel);
      // assert
      expect(result, 'success');
    },
  );

  test(
    'should return room success when create room is successful',
    () async {
      // arrange
      // act
      final result = await dataSource.createRoom(roomModel);
      // assert
      expect(result, isA<RoomModel>());
      await mockFirestore.collection('rooms').doc(result.id).delete();
    },
  );

  test(
    'should return string success when send message is successful',
    () async {
      // arrange
      // act
      final result = await dataSource.sendMessage(
          room: chatRoomModel, message: textMessage);

      // assert
      expect(result, 'success');
    },
  );

  test(
    'should return the same room when room model is already exist',
    () async {
      // arrange
      await mockFirestore.collection('rooms').add(chatRoomModel.toJson());

      // act
      final result = await dataSource.createRoom(chatRoomModel);

      // assert
      expect(result, isA<RoomModel>());
    },
  );

  group('search user profile', () {
    test(
      'should return list of users when search user profile with keyword email is successful',
      () async {
        // arrange
        await mockFirestore
            .collection('users')
            .doc('1')
            .set(userModel.toJson());
        await mockFirestore
            .collection('users')
            .doc('2')
            .set(otherUserModel.toJson());
        // act
        final result = dataSource.getUsers(emailKeyword, currentUserModel);
        // assert
        expect(await result.first, [userModel]);
      },
    );

    test(
      'should return list of users when search user profile with keyword username is successful',
      () async {
        // arrange
        await mockFirestore
            .collection('users')
            .doc('1')
            .set(userModel.toJson());
        // act
        await mockFirestore
            .collection('users')
            .doc('2')
            .set(otherUserModel.toJson());
        // assert
        final result = dataSource.getUsers(usernameKeyword, currentUserModel);

        expect(await result.first, [otherUserModel]);
      },
    );

    test(
      'should return empty list when search user profile with keyword not found',
      () async {
        // arrange
        await mockFirestore
            .collection('users')
            .doc('1')
            .set(userModel.toJson());
        await mockFirestore
            .collection('users')
            .doc('2')
            .set(otherUserModel.toJson());
        // act
        final result = dataSource.getUsers(notFoundKeyword, currentUserModel);

        // assert
        expect(await result.first, []);
      },
    );
  });

  group('fetch list of messages', () {
    test(
      'should return list of text messages when fetch messages is successful',
      () async {
        // arrange
        await mockFirestore
            .collection('rooms')
            .doc(textMessage.roomId)
            .collection('messages')
            .add(textMessage.toJson());

        // act
        final result = dataSource.getMessages(textMessage.roomId);

        // assert
        expect(await result.first, [textMessage, textMessage]);
      },
    );

    test(
      'should return list of image messages when fetch messages is successful',
      () async {
        // arrange
        await mockFirestore
            .collection('rooms')
            .doc(imageMessage.roomId)
            .collection('messages')
            .add(imageMessage.toJson());

        // act
        final result = dataSource.getMessages(imageMessage.roomId);

        // assert
        expect(await result.first, [imageMessage]);
      },
    );

    test(
      "should return empty list of messages when database doesn't have any message",
      () async {
        // arrange
        // act
        final result = dataSource.getMessages('3');
        // assert
        expect(await result.first, []);
      },
    );
  });

  group('fetch list of chat rooms', () {
    test(
      'should return list of room when fetch chat room is successful',
      () async {
        // arrange
        // act
        final result = dataSource.getRooms(currentUserModel.id);

        // assert
        expect(await result.first, isA<List<RoomModel?>>());
      },
    );

    test(
      "should return empty list of chatrooms when database doesn't have any  latest message",
      () async {
        // arrange
        final result = dataSource.getMessages('10');

        // act
        final actualResult = await result.first;

        // assert
        expect(actualResult.isEmpty, true);
      },
    );
  });
}
