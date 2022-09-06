import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/get_chat_rooms.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late GetChatRooms getChatRooms;

  setUpAll(() {
    mockRepository = MockRepository();
    getChatRooms = GetChatRooms(mockRepository);
  });

  test(
      'should return list of rooms success when fetch chat rooms is successful',
      () async {
    when(mockRepository.getRooms(currentUserModel.id))
        .thenAnswer((_) => Right(Stream.value([chatRoomModel])));

    final result = getChatRooms.getRooms(currentUserModel.id);

    expect(result.isRight(), true);
  });
}
