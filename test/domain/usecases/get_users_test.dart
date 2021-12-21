import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/get_users.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late GetUsers getUsers;

  setUpAll(() {
    mockRepository = MockRepository();
    getUsers = GetUsers(mockRepository);
  });

  test('should return list of user model when search user is successful',
      () async {
    when(mockRepository.getUsers(usernameKeyword, currentUserModel))
        .thenAnswer((_) => Right(Stream.value([userModel])));

    final result = getUsers.execute(usernameKeyword, currentUserModel);

    expect(result.isRight(), true);
  });
}
