import 'package:dartz/dartz.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/utils/failures.dart';

class LocalDataPicker {
  const LocalDataPicker(this.repository);

  final Repository repository;

  Future<Either<Failure, String?>> execute() async => repository.pickImage();
}
