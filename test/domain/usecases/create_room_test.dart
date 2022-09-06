import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_chat/domain/usecases/create_room.dart';
import 'package:mockito/mockito.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late CreateRoom createRoom;

  setUpAll(() {
    mockRepository = MockRepository();
    createRoom = CreateRoom(mockRepository);
  });

  test('should return room model when create room is successful', () async {
    when(mockRepository.createRoom(roomModel))
        .thenAnswer((_) async => const Right(roomModel));

    final result = await createRoom.execute(roomModel);

    expect(result, const Right(roomModel));
  });
}
