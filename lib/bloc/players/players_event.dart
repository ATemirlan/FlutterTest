part of 'players_bloc.dart';

@immutable
abstract class PlayersEvent {}

class LoadPlayers extends PlayersEvent {}

class UpdatePlayers extends PlayersEvent {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;
  UpdatePlayers({this.basketballPlayers, this.hockeyPlayers});
}

class ChangedIndex extends PlayersEvent {
  final int index;
  ChangedIndex(this.index);
}
