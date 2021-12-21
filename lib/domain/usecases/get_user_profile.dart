import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class GetUserProfile {
  GetUserProfile(this.repository);

  final Repository repository;

  Either<Failure, Stream<UserModel?>> execute(String id) =>
      repository.getUser(id);
}
