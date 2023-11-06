import 'package:undervoltage/domain/json/game/json_summary.dart';

class Summary {
  final Map<String, int> points;

  Summary({
    required this.points,
  });

  factory Summary.fromJson(JsonSummary json) => Summary(
        points: json.points,
      );
}
