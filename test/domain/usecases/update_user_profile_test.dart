import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/update_user_profile.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late UpdateUserProfile updateUserProfile;

  setUpAll(() {
    mockRepository = MockRepository();
    updateUserProfile = UpdateUserProfile(mockRepository);
  });

  test(
    'should return update profile when update user profile is successful',
    () async {
      when(mockRepository.updateUser(
        user: currentUserModel,
        imagePath: imagePath,
      )).thenAnswer((_) async => const Right('success'));

      final result = await updateUserProfile.execute(
        user: currentUserModel,
        imagePath: imagePath,
      );

      expect(result, const Right('success'));
    },
  );
}
