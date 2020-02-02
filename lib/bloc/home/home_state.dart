part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class DataLoading extends HomeState {}

class DataLoaded extends HomeState {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;
  final List<Message> messages;
  final int unreadBasketballPlayers;
  final int unreadHockeyPlayers;
  final int unreadMessages;

  DataLoaded({
    this.basketballPlayers,
    this.hockeyPlayers,
    this.messages,
    this.unreadBasketballPlayers,
    this.unreadHockeyPlayers,
    this.unreadMessages,
  });
}

class DataNotLoaded extends HomeState {}

class IndexChangedFromHome extends HomeState {
  final int index;
  IndexChangedFromHome(this.index);
}