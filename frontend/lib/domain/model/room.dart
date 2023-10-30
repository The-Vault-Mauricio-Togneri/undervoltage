import 'package:undervoltage/domain/model/document.dart';
import 'package:undervoltage/domain/types/room_status.dart';

class Room {
  final String id;
  final DateTime createdAt;
  final int numberOfPlayers;
  final RoomStatus status;
  final List<String> playerIds;

  Room._(
    this.id,
    this.createdAt,
    this.numberOfPlayers,
    this.status,
    this.playerIds,
  );

  factory Room.fromDocument(Document document) {
    return Room._(
      document.getString('id')!,
      document.getDateTime('createdAt')!,
      document.getNumber('numberOfPlayers')!.toInt(),
      document.getEnum(
        field: 'status',
        list: RoomStatus.values,
        mapper: (e) => e.code,
      )!,
      document.getStringList('playerIds'),
    );
  }
}
