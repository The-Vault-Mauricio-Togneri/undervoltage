import 'package:cloud_functions/cloud_functions.dart';
import 'package:dafluta/dafluta.dart';
import 'package:undervoltage/domain/model/document.dart';
import 'package:undervoltage/domain/model/room.dart';
import 'package:undervoltage/domain/types/room_visibility.dart';
import 'package:undervoltage/persistence/callables/callable.dart';

class StartMatchmakingCallable extends Callable {
  const StartMatchmakingCallable() : super('startMatchmakingCallable');

  Future<Room> call<T>({
    required String playerName,
    required String matchType,
    required int numberOfPlayers,
    required RoomVisibility visibility,
  }) async {
    final Map<String, Object?> parameters = {
      'playerName': playerName,
      'matchType': matchType,
      'numberOfPlayers': numberOfPlayers,
      'visibility': visibility.name,
    };

    final HttpsCallableResult<dynamic> result = await super.invoke(parameters);

    final Document document = Document.fromJsonObject(Json.object(result.data));

    return Room.fromDocument(document);
  }
}
