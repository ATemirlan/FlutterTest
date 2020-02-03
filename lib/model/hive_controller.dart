import 'package:faker/faker.dart';
import 'package:flutter_test_task/model/message.dart';
import 'package:flutter_test_task/model/player.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class PlayerTypes {
  static const basketball = 'BASKETBALL_PLAYER';
  static const hockey = 'HOCKEY_PLAYER';
}

class HiveController {
  static const _playersBox = 'playersBox';
  static const _messagesBox = 'messagesBox';

  static initialSetup() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlayerAdapter());
    Hive.registerAdapter(MessageAdapter());

    await _initPlayers();
    await _initMessages();
  }

  static addRandomEntity() async {
    Random().nextBool() ? await addPlayer() : await addMessage();
  }

  static addPlayer() async {
    var playersBox = await Hive.openBox(_playersBox);
    playersBox.add(_createRandomPlayer());
  }

  static addMessage() async {
    var messageBox = await Hive.openBox(_messagesBox);
    messageBox.add(await _createRandomMessage());
  }

  static makePlayerAsRead(Player player) async {
    var playersBox = await Hive.openBox(_playersBox);
    var p = playersBox.get(player.key);

    if (p is Player) {
      p.unread = false;
      p.save();
    }
  }

  static makeMessageAsRead(Message message) async {
    var messagesBox = await Hive.openBox(_messagesBox);
    var m = messagesBox.get(message.key);

    if (m is Message) {
      m.unread = false;
      m.save();
    }
  }

  static _initPlayers() async {
    var playersBox = await Hive.openBox(_playersBox);

    if (playersBox.values.length == 0) {
      final initialPlayers = _createInitialPlayers();
      playersBox.addAll(initialPlayers);
    }
  }

  static _initMessages() async {
    var messagesBox = await Hive.openBox(_messagesBox);

    if (messagesBox.values.length == 0) {
      final initialMessages = await _createInitialMessages();
      messagesBox.addAll(initialMessages);
    }
  }

  static Future<List<Message>> _createInitialMessages() async {
    List<Message> messages = [];
    final numberOfInitialMessages = getRandomNumber(5, 11);

    for (int i = 0; i < numberOfInitialMessages; i++) {
      final message = await _createRandomMessage();
      messages.add(message);
    }

    return messages;
  }

  static Future<Message> _createRandomMessage() async {
    var playersBox = await Hive.openBox(_playersBox);
    final randomPlayerIndex = getRandomNumber(0, playersBox.values.length);
    final player = playersBox.values.toList()[randomPlayerIndex] as Player;

    var message = Message();

    final faker = Faker();
    final numberOfSentences = getRandomNumber(1, 4);
    message.message = faker.lorem.sentences(numberOfSentences).join(' ');
    message.unread = true;
    message.player = player;

    return message;
  }

  static List<Player> _createInitialPlayers() {
    List<Player> players = [];
    final numberOfInitialPlayers = getRandomNumber(3, 6);

    for (int i = 0; i < numberOfInitialPlayers; i++) {
      players.add(_createRandomPlayer());
    }

    return players;
  }

  static Player _createRandomPlayer() {
    return Random().nextBool()
        ? _createRandomBasketballPlayer()
        : _createRandomHockeyPlayer();
  }

  static Player _createRandomBasketballPlayer() {
    var player = Player();

    final faker = new Faker();
    player.name = faker.person.name();
    player.unread = true;
    player.type = PlayerTypes.basketball;
    player.isLeftAlign = true;

    player.color = (Random().nextDouble() * 0xFFFFFF).toInt() << 0;
    return player;
  }

  static Player _createRandomHockeyPlayer() {
    var player = Player();

    final faker = new Faker();
    player.name = faker.person.name();
    player.unread = true;
    player.type = PlayerTypes.hockey;
    player.isLeftAlign = Random().nextBool();

    player.color = (Random().nextDouble() * 0xFFFFFF).toInt() << 0;

    return player;
  }

  static FilteredPlayersResponse getPlayers() {
    final players = Hive.box(_playersBox)
        .values
        .toList()
        .map((object) => object as Player)
        .toList();
    return FilteredPlayersResponse.from(players);
  }

  static List<Message> getMessages() {
    final messages = Hive.box(_messagesBox)
        .values
        .toList()
        .map((object) => object as Message)
        .toList();
    return messages;
  }
}

class FilteredPlayersResponse {
  final List<Player> basketballPlayers;
  final List<Player> hockeyPlayers;

  FilteredPlayersResponse({this.basketballPlayers, this.hockeyPlayers});

  factory FilteredPlayersResponse.from(List<Player> allPlayers) {
    return FilteredPlayersResponse(
      basketballPlayers:
          allPlayers.where((p) => p.type == PlayerTypes.basketball).toList(),
      hockeyPlayers:
          allPlayers.where((p) => p.type == PlayerTypes.hockey).toList(),
    );
  }
}

int getRandomNumber(int min, int max) {
  final rnd = Random();
  return min + rnd.nextInt(max - min);
}
