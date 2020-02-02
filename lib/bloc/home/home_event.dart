part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadData extends HomeEvent {}

class StartAddingData extends HomeEvent {}

class MarkMessageAsRead extends HomeEvent {
  final Message message;
  MarkMessageAsRead(this.message);
}

class MarkPlayerAsRead extends HomeEvent {
  final Player player;
  MarkPlayerAsRead(this.player);
}

class ChangeIndexFromHome extends HomeEvent {
  final int index;
  ChangeIndexFromHome(this.index);
}