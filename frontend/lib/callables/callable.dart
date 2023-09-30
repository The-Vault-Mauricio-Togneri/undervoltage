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
