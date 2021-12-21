part of 'create_room_cubit.dart';

abstract class CreateRoomState extends Equatable {
  const CreateRoomState();

  @override
  List<Object> get props => [];
}

class CreateRoomEmpty extends CreateRoomState {}

class CreateRoomLoading extends CreateRoomState {}

class CreateRoomError extends CreateRoomState {
  final String message;

  const CreateRoomError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateRoomSuccess extends CreateRoomState {
  final RoomModel room;

  const CreateRoomSuccess(this.room);

  @override
  List<Object> get props => [room];
}
