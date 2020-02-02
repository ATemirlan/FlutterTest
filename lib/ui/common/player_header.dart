import 'package:flutter/material.dart';
import 'package:flutter_test_task/model/player.dart';

class PlayerHeader extends StatelessWidget {
  final Player player;

  PlayerHeader(this.player);

  @override
  Widget build(BuildContext context) {
    final name = Text(
      player.name,
      style: TextStyle(fontSize: 20),
    );
    
    final children = player.isLeftAlign
        ? [_avatar(player.color), SizedBox(width: 8.0), name]
        : [name, SizedBox(width: 8.0), _avatar(player.color)];

    final alignment =
        player.isLeftAlign ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: alignment,
        children: children,
      ),
    );
  }

  Widget _avatar(int color) {
    final diameter = 44.0;
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: Color(color).withOpacity(1.0),
        borderRadius: BorderRadius.circular(diameter / 2),
      ),
    );
  }
}
