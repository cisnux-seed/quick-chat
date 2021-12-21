import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:quick_chat/data/datasources/local_data_source.dart';
import 'package:quick_chat/data/datasources/remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/data/repository/repository_impl.dart';
import 'package:quick_chat/utils/exceptions.dart';
import 'package:quick_chat/utils/failures.dart';
import '../../dummy/dummy_objects.dart';
import 'repository_impl_test.mocks.dart';

@GenerateMocks([
  LocalDataSource,
  RemoteDataSource,
])
void main() {
  late RepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = RepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  test('should return success when create user profile is successful',
      () async {
    // arrange
    when(mockRemoteDataSource.createUser(user: userModel, imagePath: imagePath))
        .thenAnswer((_) async => 'success');

    // act
    final result = await repository.createUser(
      user: userModel,
      imagePath: imagePath,
    );
    final actualResult = result.getOrElse(() => 'success');

    // assert
    verify(
      mockRemoteDataSource.createUser(
        user: userModel,
        imagePath: imagePath,
      ),
    );
    expect(actualResult, 'success');
  });

  group('failed to create user profile', () {
    test(
        'should return database failure when create user profile throw database exception',
        () async {
      // arrange
      when(mockRemoteDataSource.createUser(
              user: userModel, imagePath: imagePath))
          .thenThrow(DatabaseException(''));

      // act
      final result = await repository.createUser(
        user: userModel,
        imagePath: imagePath,
      );

      // assert
      verify(
        mockRemoteDataSource.createUser(
          user: userModel,
          imagePath: imagePath,
        ),
      );
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when create user profile throw socket exception',
        () async {
      // arrange
      when(mockRemoteDataSource.createUser(
              user: userModel, imagePath: imagePath))
          .thenThrow(const SocketException(''));

      // act
      final result = await repository.createUser(
        user: userModel,
        imagePath: imagePath,
      );

      // assert
      verify(
        mockRemoteDataSource.createUser(
          user: userModel,
          imagePath: imagePath,
        ),
      );
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return stream list usermodels when get users is success', () {
    // arrange
    when(mockRemoteDataSource.getUsers('fajra', userModel))
        .thenAnswer((_) => Stream.value([userModel]));
    // act
    final result = repository.getUsers('fajra', userModel);

    // assert
    verify(mockRemoteDataSource.getUsers('fajra', userModel));
    expect(result.isRight(), true);
  });

  group('failed to search user', () {
    test(
        'should return database failure when search user profile throw database exception',
        () {
      // arrange
      when(
        mockRemoteDataSource.getUsers('fajra', userModel),
      ).thenThrow(DatabaseException(''));

      // act
      final result = repository.getUsers('fajra', userModel);

      // assert
      verify(mockRemoteDataSource.getUsers('fajra', userModel));
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when search user profile throw socket exception',
        () {
      // arrange
      when(
        mockRemoteDataSource.getUsers('fajra', userModel),
      ).thenThrow(const SocketException(''));

      // act
      final result = repository.getUsers('fajra', userModel);

      // assert
      verify(mockRemoteDataSource.getUsers('fajra', userModel));
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return string success when userprofile updated', () async {
    // arrange
    when(mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath))
        .thenAnswer((_) async => 'success');

    // act
    final result =
        await repository.updateUser(user: userModel, imagePath: imagePath);
    final actualResult = result.getOrElse(() => 'success');

    // assert
    verify(
        mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath));
    expect(actualResult, 'success');
  });

  group('failed to update userprofile', () {
    test(
        'should return database failure when updated userprofile throw database exception',
        () async {
      // arrange
      when(
        mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath),
      ).thenThrow(DatabaseException(''));

      // act
      final result =
          await repository.updateUser(user: userModel, imagePath: imagePath);

      // assert
      verify(
        mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath),
      );
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when updated user profile throw socket exception',
        () async {
      // arrange
      when(
        mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath),
      ).thenThrow(const SocketException(''));

      // act
      final result =
          await repository.updateUser(user: userModel, imagePath: imagePath);

      // assert
      verify(
        mockRemoteDataSource.updateUser(user: userModel, imagePath: imagePath),
      );
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return user profile when fetch user profile is successful', () {
    // arrange
    when(mockRemoteDataSource.getUser(userModel.id))
        .thenAnswer((_) => Stream.value(userModel));

    // act
    final result = repository.getUser(userModel.id);

    // assert
    verify(mockRemoteDataSource.getUser(userModel.id));
    expect(result.isRight(), true);
  });

  group('failed to fetch userprofile', () {
    test(
        'should return database failure when fetch userprofile throw database exception',
        () async {
      // arrange
      when(mockRemoteDataSource.getUser(userModel.id))
          .thenThrow(DatabaseException(''));

      // act
      final result = repository.getUser(userModel.id);

      // assert
      verify(mockRemoteDataSource.getUser(userModel.id));
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when fetch user profile throw socket exception',
        () async {
      // arrange
      when(mockRemoteDataSource.getUser(userModel.id))
          .thenThrow(const SocketException(''));

      // act
      final result = repository.getUser(userModel.id);

      // assert
      verify(mockRemoteDataSource.getUser(userModel.id));
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return image path when select image from local is successful',
      () async {
    // arrange
    when(mockLocalDataSource.pickImage()).thenAnswer((_) async => imagePath);

    // act
    final result = await repository.pickImage();
    final actualResult = result.getOrElse(() => imagePath);

    // assert
    verify(mockLocalDataSource.pickImage());
    expect(actualResult, imagePath);
  });

  group('failed to select image from local', () {
    test(
        'should return data picker failure when select image from local has been failed',
        () async {
      // arrange
      when(mockLocalDataSource.pickImage()).thenThrow(DataPickerException(''));

      // act
      final result = await repository.pickImage();

      // assert
      verify(mockLocalDataSource.pickImage());
      expect(result, equals(const Left(DataPickerFailure(''))));
    });

    test(
        'should return connection failure when select image from local has been failed',
        () async {
      // arrange
      when(mockLocalDataSource.pickImage())
          .thenThrow(const SocketException(''));

      // act
      final result = await repository.pickImage();

      // assert
      verify(mockLocalDataSource.pickImage());
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return room when create room is successful', () async {
    // arrange
    when(mockRemoteDataSource.createRoom(roomModel))
        .thenAnswer((_) async => roomModel);

    // act
    final result = await repository.createRoom(roomModel);
    final actualResult = result.getOrElse(() => roomModel);

    // assert
    verify(mockRemoteDataSource.createRoom(roomModel));
    expect(actualResult, roomModel);
  });

  group('failed to create room chat', () {
    test('should return database failure when create chat room has been failed',
        () async {
      // arrange
      when(mockRemoteDataSource.createRoom(roomModel))
          .thenThrow(DatabaseException(''));

      // act
      final result = await repository.createRoom(roomModel);

      // assert
      verify(mockRemoteDataSource.createRoom(roomModel));
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when create chat room has been failed',
        () async {
      // arrange
      when(mockRemoteDataSource.createRoom(roomModel))
          .thenThrow(const SocketException(''));

      // act
      final result = await repository.createRoom(roomModel);

      // assert
      verify(mockRemoteDataSource.createRoom(roomModel));
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return list of messages when fetch messages is successful', () {
    // arrange
    when(mockRemoteDataSource.getMessages(roomModel.id))
        .thenAnswer((_) => Stream.value([textMessage]));

    // act
    final result = repository.getMessages(roomModel.id!);

    // assert
    verify(mockRemoteDataSource.getMessages(roomModel.id!));
    expect(result.isRight(), true);
  });

  group('failed to fetch list of messages', () {
    test(
        'should return database failure when fetch list of messages has been failed',
        () {
      // arrange
      when(mockRemoteDataSource.getMessages(roomModel.id))
          .thenThrow(DatabaseException(''));

      // act
      final result = repository.getMessages(roomModel.id!);

      // assert
      verify(mockRemoteDataSource.getMessages(roomModel.id));
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when fetch list of messages has been failed',
        () {
      // arrange
      when(mockRemoteDataSource.getMessages(roomModel.id))
          .thenThrow(const SocketException(''));

      // act
      final result = repository.getMessages(roomModel.id!);

      // assert
      verify(mockRemoteDataSource.getMessages(roomModel.id));
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return list of chat rooms when fetch rooms is successful', () {
    // arrange
    when(mockRemoteDataSource.getRooms(userModel.id))
        .thenAnswer((_) => Stream.value([roomModel]));

    // act
    final result = repository.getRooms(userModel.id);

    // assert
    verify(mockRemoteDataSource.getRooms(userModel.id));
    expect(result.isRight(), true);
  });

  group('failed to fetch list of chat rooms', () {
    test(
        'should return database failure when fetch list of chat rooms has been failed',
        () {
      // arrange
      when(mockRemoteDataSource.getRooms(userModel.id))
          .thenThrow(DatabaseException(''));

      // act
      final result = repository.getRooms(userModel.id);

      // assert
      verify(mockRemoteDataSource.getRooms(userModel.id));
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when fetch list of chat rooms has been failed',
        () {
      // arrange
      when(mockRemoteDataSource.getRooms(userModel.id))
          .thenThrow(const SocketException(''));

      // act
      final result = repository.getRooms(userModel.id);

      // assert
      verify(mockRemoteDataSource.getRooms(userModel.id));
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });

  test('should return string success when send a message is successful',
      () async {
    // arrange
    when(mockRemoteDataSource.sendMessage(
      message: imageMessage,
      imagePath: imagePath,
      room: roomModel.copyWith(
        latestMessage: 'send an picture',
        updatedAt: Timestamp.now(),
        profilePict: [otherUserModel.profilePict, userModel.profilePict],
      ),
    )).thenAnswer((_) async => 'success');

    // act
    final result = await repository.sendMessage(
      message: imageMessage,
      imagePath: imagePath,
      room: roomModel.copyWith(
        latestMessage: 'send an picture',
        updatedAt: Timestamp.now(),
        profilePict: [otherUserModel.profilePict, userModel.profilePict],
      ),
    );
    final actualResult = result.getOrElse(() => 'success');

    // assert
    verify(
      mockRemoteDataSource.sendMessage(
        message: imageMessage,
        imagePath: imagePath,
        room: roomModel.copyWith(
          latestMessage: 'send an picture',
          updatedAt: Timestamp.now(),
          profilePict: [otherUserModel.profilePict, userModel.profilePict],
        ),
      ),
    );
    expect(actualResult, 'success');
  });

  group('failed to send messages', () {
    test('should return database failure when send an message has been failed',
        () async {
      // arrange
      when(
        mockRemoteDataSource.sendMessage(
          message: imageMessage,
          imagePath: imagePath,
          room: roomModel.copyWith(
            latestMessage: 'send an picture',
            updatedAt: Timestamp.now(),
            profilePict: [otherUserModel.profilePict, userModel.profilePict],
          ),
        ),
      ).thenThrow(DatabaseException(''));

      // act
      final result = await repository.sendMessage(
        message: imageMessage,
        imagePath: imagePath,
        room: roomModel.copyWith(
          latestMessage: 'send an picture',
          updatedAt: Timestamp.now(),
          profilePict: [otherUserModel.profilePict, userModel.profilePict],
        ),
      );

      // assert
      verify(
        mockRemoteDataSource.sendMessage(
          message: imageMessage,
          imagePath: imagePath,
          room: roomModel.copyWith(
            latestMessage: 'send an picture',
            updatedAt: Timestamp.now(),
            profilePict: [otherUserModel.profilePict, userModel.profilePict],
          ),
        ),
      );
      expect(result, equals(const Left(DatabaseFailure(''))));
    });

    test(
        'should return connection failure when fetch list of chat rooms has been failed',
        () async {
      // arrange
      when(
        mockRemoteDataSource.sendMessage(
          message: imageMessage,
          imagePath: imagePath,
          room: roomModel.copyWith(
            latestMessage: 'send an picture',
            updatedAt: Timestamp.now(),
            profilePict: [otherUserModel.profilePict, userModel.profilePict],
          ),
        ),
      ).thenThrow(const SocketException(''));

      // act
      final result = await repository.sendMessage(
        message: imageMessage,
        imagePath: imagePath,
        room: roomModel.copyWith(
          latestMessage: 'send an picture',
          updatedAt: Timestamp.now(),
          profilePict: [otherUserModel.profilePict, userModel.profilePict],
        ),
      );

      // assert
      verify(
        mockRemoteDataSource.sendMessage(
          message: imageMessage,
          imagePath: imagePath,
          room: roomModel.copyWith(
            latestMessage: 'send an picture',
            updatedAt: Timestamp.now(),
            profilePict: [otherUserModel.profilePict, userModel.profilePict],
          ),
        ),
      );
      expect(
          result,
          equals(
              const Left(ConnectionFailure('Failed to connect the internet'))));
    });
  });
}
