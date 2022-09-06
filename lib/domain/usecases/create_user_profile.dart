import 'package:dartz/dartz.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class CreateUserProfile {
  CreateUserProfile(this.repository);

  final Repository repository;

  Future<Either<Failure, String>> execute({
    required UserModel user,
    String? imagePath,
  }) async =>
      repository.createUser(user: user, imagePath: imagePath);
}
