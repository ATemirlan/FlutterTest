import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/bloc/home/home_bloc.dart';
import 'package:flutter_test_task/model/hive_controller.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:meta/meta.dart';
part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final HomeBloc homeBloc;
  StreamSubscription homeSubscription;

  MessagesBloc(this.homeBloc) {
    homeSubscription = homeBloc.listen((state) {
      if (state is DataLoaded) {
        add(UpdateMessages(state.messages));
      }
    });
  }

  @override
  MessagesState get initialState => MessagesInitial();

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is UpdateMessages) {
      yield MessagesLoaded(event.messages);
    } else if (event is MessagesLoading) {
      yield MessagesLoading();
    } else if (event is LoadMessages) {
      final messages = HiveController.getMessages();
      yield MessagesLoaded(messages);
    }
  }
}
