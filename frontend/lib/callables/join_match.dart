import 'package:cloud_functions/cloud_functions.dart';
import 'package:undervoltage/callables/callable.dart';

class JoinMatch extends Callable {
  const JoinMatch() : super('joinMatch');

  Future<HttpsCallableResult<T>> call<T>({
    required String matchId,
  }) {
    final Map<String, Object?> parameters = {
      'matchId': matchId.trim(),
    };

    return super.invoke(parameters);
  }
}
