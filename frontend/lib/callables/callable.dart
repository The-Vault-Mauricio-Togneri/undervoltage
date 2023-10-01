import 'package:cloud_functions/cloud_functions.dart';
import 'package:undervoltage/environments/environment.dart';

abstract class Callable {
  final String name;

  const Callable(this.name);

  Future<HttpsCallableResult<T>> invoke<T>([dynamic parameters]) async {
    final HttpsCallable callable = _callable(name: name);

    return callable.call(parameters);
  }

  HttpsCallable _callable({
    required String name,
  }) {
    if (Environment.get.isLocal) {
      FirebaseFunctions.instance.useFunctionsEmulator('10.0.2.2', 5001);

      return FirebaseFunctions.instance.httpsCallableFromUrl(
        'http://10.0.2.2:5001/tensionplanet/us-central1/$name',
      );
    } else {
      return FirebaseFunctions.instance.httpsCallable(
        name,
      );
    }
  }
}
