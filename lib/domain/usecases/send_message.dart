import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class SendMessage {
  SendMessage(this.repository);

  final Repository repository;

  Future<Either<Failure, String>> executeSendMessage({
    dynamic message,
    String? imagePath,
    required RoomModel room,
  }) async =>
      repository.sendMessage(message: message, imagePath: imagePath, room: room,);
}
