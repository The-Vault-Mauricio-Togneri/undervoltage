import 'package:tensionpath/persistence/callables/callable.dart';

class StopMatchmakingCallable extends Callable {
  const StopMatchmakingCallable() : super('stopMatchmakingCallable');

  Future call<T>({
    required String roomId,
  }) {
    final Map<String, Object?> parameters = {
      'roomId': roomId,
    };

    return super.invoke(parameters);
  }
}
