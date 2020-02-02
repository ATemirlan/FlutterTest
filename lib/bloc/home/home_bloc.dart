import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/model/hive_controller.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:flutter_test_task/model/player.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadData) {
      final messages = HiveController.getMessages();
      final players = HiveController.getPlayers();
      final basketballPlayers = players.basketballPlayers;
      final hockeyPlayers = players.hockeyPlayers;

      yield DataLoaded(
        basketballPlayers: basketballPlayers,
        hockeyPlayers: hockeyPlayers,
        unreadBasketballPlayers:
            basketballPlayers.where((m) => m.unread).toList().length,
        unreadHockeyPlayers:
            hockeyPlayers.where((m) => m.unread).toList().length,
        messages: messages,
        unreadMessages: messages.where((m) => m.unread).toList().length,
      );
    } else if (event is StartAddingData) {
      await HiveController.addRandomEntity();
      add(LoadData());
    } else if (event is MarkMessageAsRead) {
      await HiveController.makeMessageAsRead(event.message);
      add(LoadData());
    } else if (event is MarkPlayerAsRead) {
      await HiveController.makePlayerAsRead(event.player);
      add(LoadData());
    } else if (event is ChangeIndexFromHome) {
      yield IndexChangedFromHome(event.index);
    }
  }
}
