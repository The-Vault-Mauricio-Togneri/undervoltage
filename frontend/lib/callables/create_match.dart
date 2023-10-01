import 'package:cloud_functions/cloud_functions.dart';
import 'package:undervoltage/callables/callable.dart';

class CreateMatch extends Callable {
  const CreateMatch() : super('createMatch');

  Future<HttpsCallableResult<T>> call<T>({
    required int numberOfPlayers,
    required int maxPoints,
  }) {
    final Map<String, Object?> parameters = {
      'numberOfPlayers': numberOfPlayers,
      'maxPoints': maxPoints,
    };

    return super.invoke(parameters);
  }
}
