part of 'get_messages_cubit.dart';

abstract class GetMessagesState extends Equatable {
  const GetMessagesState();

  @override
  List<Object> get props => [];
}

class GetMessagesEmpty extends GetMessagesState {}

class GetMessagesLoading extends GetMessagesState {}

class GetMessagesError extends GetMessagesState {
  final String message;

  const GetMessagesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetMessagesSuccess extends GetMessagesState {
  final List<dynamic> messages;

  const GetMessagesSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}
