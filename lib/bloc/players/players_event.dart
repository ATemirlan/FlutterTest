part of 'players_bloc.dart';

@immutable
abstract class PlayersEvent {}

class PlayersLoad extends PlayersEvent {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;
  PlayersLoad({this.basketballPlayers, this.hockeyPlayers});
}

class ChangedIndex extends PlayersEvent {
  final int index;
  ChangedIndex(this.index);
}
