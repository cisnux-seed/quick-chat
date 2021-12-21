part of 'get_chat_rooms_cubit.dart';

abstract class GetChatRoomsState extends Equatable {
  const GetChatRoomsState();

  @override
  List<Object> get props => [];
}

class GetChatRoomsEmpty extends GetChatRoomsState {}

class GetChatRoomsLoading extends GetChatRoomsState {}

class GetChatRoomsError extends GetChatRoomsState {
  final String message;

  const GetChatRoomsError(this.message);

  @override
  List<Object> get props => [message];
}

class GetChatRoomsSuccess extends GetChatRoomsState {
  final List<RoomModel?> roomModels;

  const GetChatRoomsSuccess(this.roomModels);

  @override
  List<Object> get props => [roomModels];
}
