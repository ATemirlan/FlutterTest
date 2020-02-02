import 'package:flutter_test_task/model/player.dart';
import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  bool unread;

  @HiveField(2)
  Player player;
}