import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class GetChatRooms {
  const GetChatRooms(this.repository);

  final Repository repository;

  Either<Failure, Stream<List<RoomModel?>>> getRooms(String currentUserId) =>
      repository.getRooms(currentUserId);
}
