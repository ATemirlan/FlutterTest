import 'dart:async';
import 'package:flutter_test_task/model/hive_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';

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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(body: _body(state));
      },
    );
  }

  Widget _body(HomeState state) {
    print(state);
    if (state is DataLoaded) return _dataLoadedBody(state);
    return Container();
  }

  Widget _dataLoadedBody(DataLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _circleButton(
              icon: Image.asset('assets/basketball.png'),
              badge: state.unreadBasketballPlayers,
              onTap: () {
                widget.toBasketballPlayers();
              },
            ),
            SizedBox(width: 16.0),
            _circleButton(
              icon: Image.asset('assets/hockey.png'),
              badge: state.unreadHockeyPlayers,
              onTap: () => widget.toHockeyPlayers(),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        _circleButton(
          icon: Icon(Icons.message),
          badge: state.unreadMessages,
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
