part of 'players_bloc.dart';

class PlayersState {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;
  final int index;

  PlayersState({
    this.basketballPlayers,
    this.hockeyPlayers,
    this.index,
  });

  PlayersState copyWith({
    List<Player> basketballPlayers,
    List<Player> hockeyPlayers,
    int index,
  }) {
    return PlayersState(
      basketballPlayers: basketballPlayers ?? this.basketballPlayers,
      hockeyPlayers: hockeyPlayers ?? this.hockeyPlayers,
      index: index ?? this.index,
    );
  }
}
