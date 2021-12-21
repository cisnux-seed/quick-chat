import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/utils/failures.dart';

abstract class Repository {
  Either<Failure, Stream<List<UserModel>>> getUsers(
    String keyword,
    UserModel currentUser,
  );
  Future<Either<Failure, String>> createUser({
    required UserModel user,
    String? imagePath,
  });
  Future<Either<Failure, String>> sendMessage({
    dynamic message,
    String? imagePath,
    required RoomModel room,
  });
  Future<Either<Failure, String>> updateUser({
    required UserModel user,
    String? imagePath,
  });
  Either<Failure, Stream<UserModel?>> getUser(String id);
  Either<Failure, Stream<List<dynamic>>> getMessages(String roomId);

  Either<Failure, Stream<List<RoomModel?>>> getRooms(String currentUserId);
  Future<Either<Failure, String?>> pickImage();
  Future<Either<Failure, RoomModel>> createRoom(RoomModel room);
}
