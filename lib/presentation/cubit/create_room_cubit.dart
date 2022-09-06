import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/room_model.dart';
import 'package:quick_chat/domain/usecases/create_room.dart';

part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit(this.createRoom) : super(CreateRoomEmpty());

  final CreateRoom createRoom;

  Future<void> createChatRoom(RoomModel room) async {
    emit(CreateRoomLoading());
    final result = await createRoom.execute(room);
    result.fold(
      (failure) => emit(CreateRoomError(failure.message)),
      (success) => emit(CreateRoomSuccess(success)),
    );
  }
}
