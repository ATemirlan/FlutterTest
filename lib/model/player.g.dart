// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final typeId = 0;

  @override
  Player read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player()
      ..color = fields[0] as int
      ..name = fields[1] as String
      ..unread = fields[2] as bool
      ..type = fields[3] as String
      ..isLeftAlign = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unread)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isLeftAlign);
  }
}
