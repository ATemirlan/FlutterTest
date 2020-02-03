import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/bloc/messages/messages_bloc.dart';
import 'package:flutter_test_task/bloc/players/players_bloc.dart';
import 'package:flutter_test_task/model/hive_controller.dart';
import 'package:flutter_test_task/ui/messages_page.dart';
import 'package:flutter_test_task/ui/players_page.dart';

import 'home_page.dart';

class GlobalContainer extends StatefulWidget {
  @override
  _GlobalContainerState createState() => _GlobalContainerState();
}

class _GlobalContainerState extends State<GlobalContainer>
    with TickerProviderStateMixin {
  final activeColors = [
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];

  List<Widget> containers = [];
  TabController _tabController;

  AnimationController playersTopToBottomAnimationController;
  Animation<Offset> playersHeaderTopToBottomOffset;
  AnimationController playersleftToRightAnimationController;
  Animation<Offset> playersHeaderleftToRightOffset;
  Animation<Offset> playersHeaderOffset;
  AnimationController messagesAnimationController;
  Animation<Offset> messagesHeaderOffset;
  final standardDuration = Duration(milliseconds: 300);
  final nilDuration = Duration(milliseconds: 0);

  Timer timer;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupTab();
    _setupContainers();
    _setupAnimation();
    _startAddEntitiesRandomly();
  }

  _startAddEntitiesRandomly() {
    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: getRandomNumber(1, 6)),
          (t) => BlocProvider.of<HomeBloc>(context).add(StartAddingData()));
    }
  }

  _setupTab() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  _setupContainers() {
    containers = [
      HomePage(
        toBasketballPlayers: () {
          _tabController.animateTo(1);
          selectedIndex = 0;
          BlocProvider.of<HomeBloc>(context)
              .add(ChangeIndexFromHome(selectedIndex));
        },
        toHockeyPlayers: () {
          _tabController.animateTo(1);
          selectedIndex = 1;
          BlocProvider.of<HomeBloc>(context)
              .add(ChangeIndexFromHome(selectedIndex));
        },
        toMessages: () {
          _tabController.animateTo(2);
        },
      ),
      BlocProvider(
        child: PlayersPage(),
        create: (_) =>
            PlayersBloc(BlocProvider.of<HomeBloc>(context))..add(LoadPlayers()),
      ),
      BlocProvider(
        child: MessagesPage(),
        create: (_) => MessagesBloc(BlocProvider.of<HomeBloc>(context)),
      ),
    ];
  }

  _setupAnimation() {
    playersTopToBottomAnimationController =
        AnimationController(vsync: this, duration: standardDuration);
    playersHeaderTopToBottomOffset =
        Tween<Offset>(begin: Offset(0, -3), end: Offset.zero)
            .animate(playersTopToBottomAnimationController);

    playersleftToRightAnimationController =
        AnimationController(vsync: this, duration: standardDuration);
    playersHeaderleftToRightOffset =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
            .animate(playersleftToRightAnimationController);
    playersHeaderOffset = playersHeaderTopToBottomOffset;

    messagesAnimationController =
        AnimationController(vsync: this, duration: standardDuration);
    messagesHeaderOffset = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
        .animate(messagesAnimationController);
  }

  _handleTabSelection() {
    setState(() {});

    if (_zeroToOne()) {
      _topToBottomStandardAnimation(true);
    } else if (_zeroToTwo()) {
      _leftToRightNilAnimation(true);
      messagesAnimationController.forward();
    } else if (_oneToZero()) {
      playersHeaderOffset = playersHeaderTopToBottomOffset;
      _topToBottomStandardAnimation(false);
    } else if (_oneToTwo()) {
      _leftToRightStandardAnimation(true);
      messagesAnimationController.forward();
    } else if (_twoToZero()) {
      _topToBottomNilAnimation(false);
      messagesAnimationController.reverse();
    } else if (_twoToOne()) {
      _leftToRightStandardAnimation(false);
      messagesAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: containers,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: playersHeaderOffset,
                  child: _playersHeader(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SlideTransition(
                  position: messagesHeaderOffset,
                  child: _messagesHeader(),
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: _footer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playersHeader() {
    return Container(
      height: 44.0,
      child: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.7),
        title: Row(
          children: <Widget>[
            Expanded(
              child: _playersHeaderButton(
                title: 'Basketball',
                isSelected: selectedIndex == 0,
                onPressed: () {
                  selectedIndex = 0;
                  BlocProvider.of<HomeBloc>(context)
                      .add(ChangeIndexFromHome(0));
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: _playersHeaderButton(
                title: 'Hockey',
                isSelected: selectedIndex == 1,
                onPressed: () {
                  selectedIndex = 1;
                  BlocProvider.of<HomeBloc>(context)
                      .add(ChangeIndexFromHome(1));
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playersHeaderButton(
      {String title, bool isSelected, Function onPressed}) {
    return FlatButton(
      color: isSelected ? Colors.green : Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }

  Widget _messagesHeader() {
    return Container(
      height: 44.0,
      child: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.7),
        title: Text('Messages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              _tabController.animateTo(_tabController.previousIndex),
        ),
      ),
    );
  }

  Widget _footer() {
    return Container(
      color: Colors.black,
      child: TabBar(
        onTap: (index) {
          _tabController.animateTo(index);
          setState(() {});
        },
        controller: _tabController,
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              color: _tabController.index == 0 ? activeColors[0] : Colors.white,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.fitness_center,
              color: _tabController.index == 1 ? activeColors[1] : Colors.white,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.message,
              color: _tabController.index == 2 ? activeColors[2] : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  _topToBottomNilAnimation(bool forward) {
    playersHeaderOffset = playersHeaderTopToBottomOffset;
    playersTopToBottomAnimationController.duration = nilDuration;

    if (forward) {
      playersTopToBottomAnimationController.forward();
    } else {
      playersTopToBottomAnimationController.reverse();
    }
  }

  _topToBottomStandardAnimation(bool forward) {
    playersHeaderOffset = playersHeaderTopToBottomOffset;
    playersTopToBottomAnimationController.duration = standardDuration;

    if (forward) {
      playersTopToBottomAnimationController.forward();
    } else {
      playersTopToBottomAnimationController.reverse();
    }
  }

  _leftToRightNilAnimation(bool forward) {
    playersHeaderOffset = playersHeaderleftToRightOffset;
    playersleftToRightAnimationController.duration = nilDuration;

    if (forward) {
      playersleftToRightAnimationController.forward();
    } else {
      playersleftToRightAnimationController.reverse();
    }
  }

  _leftToRightStandardAnimation(bool forward) {
    playersHeaderOffset = playersHeaderleftToRightOffset;
    playersleftToRightAnimationController.duration = standardDuration;

    if (forward) {
      playersleftToRightAnimationController.forward();
    } else {
      playersleftToRightAnimationController.reverse();
    }
  }

  bool _zeroToOne() {
    return _tabController.previousIndex == 0 && _tabController.index == 1;
  }

  bool _zeroToTwo() {
    return _tabController.previousIndex == 0 && _tabController.index == 2;
  }

  bool _oneToZero() {
    return _tabController.previousIndex == 1 && _tabController.index == 0;
  }

  bool _oneToTwo() {
    return _tabController.previousIndex == 1 && _tabController.index == 2;
  }

  bool _twoToOne() {
    return _tabController.previousIndex == 2 && _tabController.index == 1;
  }

  bool _twoToZero() {
    return _tabController.previousIndex == 2 && _tabController.index == 0;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    timer.cancel();
    playersleftToRightAnimationController.dispose();
    playersTopToBottomAnimationController.dispose();
    messagesAnimationController.dispose();
  }
}
