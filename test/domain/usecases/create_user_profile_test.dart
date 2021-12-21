import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/create_user_profile.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late CreateUserProfile createUserProfile;

  setUpAll(() {
    mockRepository = MockRepository();
    createUserProfile = CreateUserProfile(mockRepository);
  });

  test('should return string success when create user profile is successful',
      () async {
    when(mockRepository.createUser(user: userModel, imagePath: imagePath))
        .thenAnswer((_) async => const Right('success'));

    final result =
        await createUserProfile.execute(user: userModel, imagePath: imagePath);

    expect(result, const Right('success'));
  });
}
