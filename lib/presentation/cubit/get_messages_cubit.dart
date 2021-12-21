import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/domain/usecases/get_messages.dart';
import 'dart:async';

part 'get_messages_state.dart';

class GetMessagesCubit extends Cubit<GetMessagesState> {
  GetMessagesCubit(this.getMessages) : super(GetMessagesEmpty());

  final GetMessages getMessages;
  StreamSubscription<List<dynamic>>? _messagesListener;

  void getUserMessages(String roomId) {
    emit(GetMessagesLoading());
    final result = getMessages.getMessages(roomId);
    result.fold(
      (failure) => emit(GetMessagesError(failure.message)),
      (success) => _messagesListener =
          success.listen((messages) => emit(GetMessagesSuccess(messages))),
    );
  }

  @override
  Future<void> close() async {
    if (_messagesListener != null) {
      await _messagesListener?.cancel();
    }
    return super.close();
  }
}
