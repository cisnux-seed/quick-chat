part of 'send_message_cubit.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageEmpty extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageError extends SendMessageState {
  final String message;

  const SendMessageError(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageSuccess extends SendMessageState {
  final String message;

  const SendMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}
