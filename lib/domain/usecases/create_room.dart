import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class CreateRoom {
  Repository repository;

  CreateRoom(this.repository);

  Future<Either<Failure, RoomModel>> execute(RoomModel room) =>
      repository.createRoom(room);
}
