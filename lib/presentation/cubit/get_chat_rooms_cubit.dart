import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/usecases/get_chat_rooms.dart';

part 'get_chat_rooms_state.dart';

class GetChatRoomsCubit extends Cubit<GetChatRoomsState> {
  GetChatRoomsCubit(this.getChatRooms) : super(GetChatRoomsEmpty());

  final GetChatRooms getChatRooms;
  StreamSubscription<List<RoomModel?>>? _roomListener;

  void fetchChatRooms(String currentUserId) {
    emit(GetChatRoomsLoading());
    final result = getChatRooms.getRooms(currentUserId);
    result.fold(
      (failure) => emit(GetChatRoomsError(failure.message)),
      (success) => _roomListener =
          success.listen((rooms) => emit(GetChatRoomsSuccess(rooms))),
    );
  }

  @override
  Future<void> close() {
    if (_roomListener != null) {
      _roomListener?.cancel();
    }
    return super.close();
  }
}
