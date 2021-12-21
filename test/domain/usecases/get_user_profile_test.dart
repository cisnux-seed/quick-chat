import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/get_user_profile.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late GetUserProfile getUserProfile;

  setUpAll(() {
    mockRepository = MockRepository();
    getUserProfile = GetUserProfile(mockRepository);
  });

  test('should return user profile when fetch user profile is successful',
      () async {
    when(mockRepository.getUser(currentUserModel.id))
        .thenAnswer((_) => Right(Stream.value(currentUserModel)));

    final result = getUserProfile.execute(currentUserModel.id);

    expect(result.isRight(), true);
  });
}
