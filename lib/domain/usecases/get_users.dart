import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class GetUsers {
  const GetUsers(this.repository);

  final Repository repository;

  Either<Failure, Stream<List<UserModel>>> execute(
    String keyword,
    UserModel currentUser,
  ) =>
      repository.getUsers(keyword, currentUser);
}
