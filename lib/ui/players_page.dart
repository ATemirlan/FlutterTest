import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/bloc/players/players_bloc.dart';
import 'package:flutter_test_task/model/player.dart';
import 'package:flutter_test_task/ui/common/player_header.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class PlayersPage extends StatefulWidget {
  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context).add(LoadPlayers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayersState>(
      builder: (context, state) {
        return Scaffold(
          body: _body(state),
        );
      },
    );
  }

  Widget _body(PlayersState state) {
    print(state.index);

    return state.index == 0
        ? _dataLoadedBody(state.basketballPlayers)
        : _dataLoadedBody(state.hockeyPlayers);
  }

  Widget _dataLoadedBody(List<Player> players) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 44, bottom: 44),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return VisibilityDetector(
            key: Key(player.name + player.type),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction > 0.2 && player.unread) {
                BlocProvider.of<HomeBloc>(context)
                    .add(MarkPlayerAsRead(player));
              }
            },
            child: Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlayerHeader(player),
              ),
            ),
          );
        },
      ),
    );
  }
}
