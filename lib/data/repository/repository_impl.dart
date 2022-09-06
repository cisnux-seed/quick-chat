import 'dart:io';

import 'package:quick_chat/data/datasources/local_data_source.dart';
import 'package:quick_chat/data/datasources/remote_data_source.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/exceptions.dart';
import 'package:quick_chat/utils/failures.dart';

class RepositoryImpl implements Repository {
  const RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> createUser({
    required UserModel user,
    String? imagePath,
  }) async {
    try {
      final result = await remoteDataSource.createUser(
        user: user,
        imagePath: imagePath,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Either<Failure, Stream<List<UserModel>>> getUsers(
    String keyword,
    UserModel currentUser,
  ) {
    try {
      final result = remoteDataSource.getUsers(keyword, currentUser);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser({
    required UserModel user,
    String? imagePath,
  }) async {
    try {
      final result = await remoteDataSource.updateUser(
        user: user,
        imagePath: imagePath,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Either<Failure, Stream<UserModel?>> getUser(String id) {
    try {
      final result = remoteDataSource.getUser(id);
      return Right(result.map((usermodel) {
        if (usermodel != null) {
          return usermodel;
        } else {
          return null;
        }
      }));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Future<Either<Failure, String?>> pickImage() async {
    try {
      final result = await localDataSource.pickImage();
      if (result != null) {
        return Right(result);
      } else {
        return const Right(null);
      }
    } on DataPickerException catch (e) {
      return Left(DataPickerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Future<Either<Failure, RoomModel>> createRoom(RoomModel room) async {
    try {
      final result = await remoteDataSource.createRoom(room);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Either<Failure, Stream<List<dynamic>>> getMessages(String roomId) {
    try {
      final result = remoteDataSource.getMessages(roomId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Either<Failure, Stream<List<RoomModel?>>> getRooms(
    String currentUserId,
  ) {
    try {
      final result = remoteDataSource.getRooms(currentUserId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> sendMessage({
    dynamic message,
    String? imagePath,
    required RoomModel room,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        message: message,
        imagePath: imagePath,
        room: room,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect the internet'));
    }
  }
}
