part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class UpdateMessages extends MessagesEvent {
  final List<Message> messages;
  UpdateMessages(this.messages);
}

class LoadMessages extends MessagesEvent {}