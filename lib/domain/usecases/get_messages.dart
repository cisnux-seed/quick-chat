import 'package:dartz/dartz.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class GetMessages {
  const GetMessages(this.repository);

  final Repository repository;

  Either<Failure, Stream<List<dynamic>>> getMessages(String roomId) =>
      repository.getMessages(roomId);
}
