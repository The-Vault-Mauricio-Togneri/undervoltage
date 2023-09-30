import 'package:cloud_functions/cloud_functions.dart';
import 'package:undervoltage/callables/callable.dart';

class CreateMatch extends Callable {
  const CreateMatch() : super('createMatch');

  Future<HttpsCallableResult<T>> call<T>({
    required String text,
  }) {
    final Map<String, Object?> parameters = {
      'text': text,
    };

    return super.invoke(parameters);
  }
}
