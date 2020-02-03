import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:flutter_test_task/model/player.dart';

class HomePage extends StatefulWidget {
  final Function toBasketballPlayers;
  final Function toHockeyPlayers;
  final Function toMessages;

  HomePage({
    this.toBasketballPlayers,
    this.toHockeyPlayers,
    this.toMessages,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int unreadBasketballPlayers = 0;
  int unreadHockeyPlayers = 0;
  int unreadMessages = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(body: _body(state));
      },
    );
  }

  Widget _body(HomeState state) {
    if (state is DataLoaded) {
      unreadBasketballPlayers = state.unreadBasketballPlayers;
      unreadHockeyPlayers = state.unreadHockeyPlayers;
      unreadMessages = state.unreadMessages;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _circleButton(
              icon: Image.asset('assets/basketball.png'),
              badge: unreadBasketballPlayers,
              onTap: () => widget.toBasketballPlayers(),
            ),
            SizedBox(width: 16.0),
            _circleButton(
              icon: Image.asset('assets/hockey.png'),
              badge: unreadHockeyPlayers,
              onTap: () => widget.toHockeyPlayers(),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        _circleButton(
          icon: Icon(Icons.message),
          badge: unreadMessages,
          onTap: () => widget.toMessages(),
        ),
      ],
    );
  }

  Widget _circleButton({int badge, Widget icon, Function onTap}) {
    return FloatingActionButton(
      onPressed: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          icon,
          Align(
            alignment: Alignment.topRight,
            child: _badge(badge),
          ),
        ],
      ),
    );
  }

  Widget _badge(int number) {
    if (number == 0) return Container();

    final diameter = 20.0;
    final badgeText = number > 9 ? '9+' : '$number';
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(diameter / 2),
      ),
      child: Center(
        child: Text(
          badgeText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
