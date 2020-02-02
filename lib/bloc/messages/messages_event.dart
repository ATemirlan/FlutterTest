part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class MessagesLoad extends MessagesEvent {
  final List<Message> messages;
  MessagesLoad(this.messages);
}