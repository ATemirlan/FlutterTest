import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/model/player.dart';
import 'package:meta/meta.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  final HomeBloc homeBloc;
  StreamSubscription homeSubscription;

  PlayersBloc(this.homeBloc) {
    homeSubscription = homeBloc.listen((state) {
      if (state is DataLoaded) {
        add(PlayersLoad(
          basketballPlayers: state.basketballPlayers,
          hockeyPlayers: state.hockeyPlayers,
        ));
      } else if (state is IndexChangedFromHome) {
        add(ChangedIndex(state.index));
      }
    });
  }

  @override
  PlayersState get initialState => PlayersInitial();

  @override
  Stream<PlayersState> mapEventToState(
    PlayersEvent event,
  ) async* {
    if (event is PlayersLoad) {
      yield PlayersLoaded(
        basketballPlayers: event.basketballPlayers,
        hockeyPlayers: event.hockeyPlayers,
      );
    } else if (event is ChangedIndex) {
      yield PlayersIndexChanged(event.index);
    }
  }
}
