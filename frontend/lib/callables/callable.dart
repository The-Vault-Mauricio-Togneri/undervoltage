import 'package:cloud_functions/cloud_functions.dart';

abstract class Callable {
  final String name;

  const Callable(this.name);

  Future<HttpsCallableResult<T>> invoke<T>([dynamic parameters]) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable(name);

    return callable.call(parameters);
  }
}

class CallableError {
  final String code;
  final Map<String, Object> data;

  const CallableError(this.code, this.data);

  factory CallableError.load(FirebaseFunctionsException exception) {
    try {
      final String code = exception.details['code'];
      final Map<Object?, Object?> data = exception.details['data'];
      final Map<String, Object> dataCleaned = {};

      for (final MapEntry<Object?, Object?> entry in data.entries) {
        if ((entry.key != null) && (entry.value != null)) {
          dataCleaned[entry.key.toString()] = entry.value!;
        }
      }

      return CallableError(code, dataCleaned);
    } catch (e) {
      return const CallableError('', {});
    }
  }
}
