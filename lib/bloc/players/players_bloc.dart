import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/model/player.dart';
import 'package:meta/meta.dart';
import '../../model/hive_controller.dart';
part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  final HomeBloc homeBloc;
  StreamSubscription homeSubscription;

  PlayersBloc(this.homeBloc) {
    homeSubscription = homeBloc.listen((state) {
      if (state is DataLoaded) {
        add(UpdatePlayers(
          basketballPlayers: state.basketballPlayers,
          hockeyPlayers: state.hockeyPlayers,
        ));
      } else if (state is IndexChangedFromHome) {
        add(ChangedIndex(state.index));
      }
    });
  }

  @override
  PlayersState get initialState =>
      PlayersState(basketballPlayers: [], hockeyPlayers: [], index: 0);

  @override
  Stream<PlayersState> mapEventToState(
    PlayersEvent event,
  ) async* {
    if (event is UpdatePlayers) {
      yield state.copyWith(
        basketballPlayers: event.basketballPlayers,
        hockeyPlayers: event.hockeyPlayers,
      );
    } else if (event is ChangedIndex) {
      yield state.copyWith(index: event.index);
    } else if (event is LoadPlayers) {
      final players = HiveController.getPlayers();
      yield state.copyWith(
        basketballPlayers: players.basketballPlayers,
        hockeyPlayers: players.hockeyPlayers,
      );
    }
  }
}
