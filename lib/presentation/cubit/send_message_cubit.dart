import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/usecases/send_message.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit({required this.sendMessage}) : super(SendMessageEmpty());

  final SendMessage sendMessage;

  Future<void> sendMessages({
    required dynamic message,
    String? imagePath,
    required RoomModel room,
  }) async {
    emit(SendMessageLoading());
    final result = await sendMessage.executeSendMessage(
      message: message,
      imagePath: imagePath,
      room: room,
    );
    result.fold(
      (failure) => emit(SendMessageError(failure.message)),
      (success) => emit(SendMessageSuccess(success)),
    );
  }
}
