import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/get_messages.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late GetMessages getMessages;

  setUpAll(() {
    mockRepository = MockRepository();
    getMessages = GetMessages(mockRepository);
  });

  test(
      'should return list of messsages success when fetch messages is successful',
      () async {
    when(mockRepository.getMessages(roomModel.id))
        .thenAnswer((_) => Right(Stream.value([textMessage, imageMessage])));

    final result = getMessages.getMessages(roomModel.id!);

    expect(result.isRight(), true);
  });
}
