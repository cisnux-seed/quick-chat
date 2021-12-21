import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/send_message.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late SendMessage sendMessage;

  setUpAll(() {
    mockRepository = MockRepository();
    sendMessage = SendMessage(mockRepository);
  });

  test(
    'should return string success when send a message is successful',
    () async {
      when(mockRepository.sendMessage(
        message: imageMessage,
        imagePath: imagePath,
        room: chatRoomModel,
      )).thenAnswer((_) async => const Right('success'));

      final result = await sendMessage.executeSendMessage(
        message: imageMessage,
        imagePath: imagePath,
        room: chatRoomModel,
      );

      expect(result, const Right('success'));
    },
  );
}
