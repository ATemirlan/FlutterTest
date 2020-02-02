import 'package:flutter/material.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:flutter_test_task/ui/common/player_header.dart';

class MessageContainer extends StatefulWidget {
  final Message message;

  MessageContainer(this.message);

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PlayerHeader(widget.message.player),
              SizedBox(height: 8),
              _message(),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _message() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: Text(
          widget.message.message,
          maxLines: !isExpanded ? 1 : 100,
          overflow: TextOverflow.fade,
          softWrap: isExpanded,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
