import 'package:hive/hive.dart';
part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  int color;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool unread;

  @HiveField(3)
  String type;

  @HiveField(4)
  bool isLeftAlign;
}
