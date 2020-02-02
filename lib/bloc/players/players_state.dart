part of 'players_bloc.dart';

@immutable
abstract class PlayersState {}

class PlayersInitial extends PlayersState {}

class PlayersLoaded extends PlayersState {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;
  PlayersLoaded({this.basketballPlayers, this.hockeyPlayers});
}

class PlayersIndexChanged extends PlayersState {
  final int index;
  PlayersIndexChanged(this.index);
}
