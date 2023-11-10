import 'package:undervoltage/domain/models/document.dart';

class Match {
  final String id;
  final DateTime createdAt;
  final int numberOfPlayers;
  final List<String> playerIds;
  final Map<String, int> scores;

  Match._(
    this.id,
    this.createdAt,
    this.numberOfPlayers,
    this.playerIds,
    this.scores,
  );

  int get maxPoints => numberOfPlayers * 50;

  List<MapEntry<String, int>> get scoresTable {
    final List<MapEntry<String, int>> result = scores.entries.toList();
    result.sort((a, b) => a.value - b.value);

    return result;
  }

  factory Match.fromDocument(Document document) {
    final Document scoresDocument = document.getDocument('scores');
    final Map<String, int> scores = {};

    for (final String playerName in scoresDocument.fieldNames) {
      scores[playerName] = scoresDocument.getNumber(playerName)!.toInt();
    }

    return Match._(
      document.getString('id')!,
      document.getDateTime('createdAt')!,
      document.getNumber('numberOfPlayers')!.toInt(),
      document.getStringList('playerIds'),
      scores,
    );
  }
}
