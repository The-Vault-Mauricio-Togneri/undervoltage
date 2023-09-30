import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/json/json_output_message.dart';
import 'package:undervoltage/services/connection.dart';

class Echo {
  final String matchId;
  final Connection connection;
  bool enabled = true;
  int sum = 0;
  int count = 0;
  DateTime? sentTimestamp;

  Echo(this.matchId, this.connection);

  void send() {
    if (enabled) {
      sentTimestamp = DateTime.now();
      connection.send(JsonOutputMessage.echo(matchId));
    }
  }

  void received() {
    final int diff = DateTime.now().difference(sentTimestamp!).inMilliseconds;
    sum += diff;
    count++;
  }

  double average() {
    enabled = false;
    final double average = (count == 0) ? 0 : ((sum / count) / 1000);

    return (average > Constants.MAX_LATENCY) ? Constants.MAX_LATENCY : average;
  }
}
