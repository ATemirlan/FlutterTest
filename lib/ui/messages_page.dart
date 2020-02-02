import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/bloc/messages/messages_bloc.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'common/message_container.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (context, state) {
        return Scaffold(body: _body(state));
      },
    );
  }

  Widget _body(MessagesState state) {
    if (state is MessagesLoaded) return _dataLoadedBody(state.messages);
    return Container();
  }

  Widget _dataLoadedBody(List<Message> messages) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return VisibilityDetector(
            key: Key(message.player.name + message.message),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction > 0.2 && message.unread) {
                BlocProvider.of<HomeBloc>(context).add(MarkMessageAsRead(message));
              }
            },
            child: MessageContainer(message),
          );
        },
      ),
    );
  }
}
