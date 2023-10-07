import 'package:cloud_functions/cloud_functions.dart';
import 'package:undervoltage/callables/callable.dart';

class PlayCard extends Callable {
  const PlayCard() : super('playCard');

  Future<HttpsCallableResult<T>> call<T>({
    required String matchId,
    required String cardId,
  }) {
    final Map<String, Object?> parameters = {
      'matchId': matchId.trim(),
      'cardId': cardId.trim(),
    };

    return super.invoke(parameters);
  }
}
