import 'package:undervoltage/domain/json/game/json_summary.dart';

class Summary {
  final Map<String, int> points = {};

  Summary();

  JsonSummary get json => JsonSummary(points: points);

  void add(String playerId, int points) => this.points[playerId] = points;
}
