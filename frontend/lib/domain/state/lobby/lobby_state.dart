import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dafluta/dafluta.dart';
import 'package:undervoltage/domain/model/document.dart';
import 'package:undervoltage/domain/model/room.dart';
import 'package:undervoltage/domain/model/user_logged.dart';
import 'package:undervoltage/domain/types/room_status.dart';
import 'package:undervoltage/domain/types/room_visibility.dart';
import 'package:undervoltage/persistence/callables/start_matchmaking_callable.dart';
import 'package:undervoltage/persistence/callables/stop_matchmaking_callable.dart';
import 'package:undervoltage/presentation/dialogs/info_dialog.dart';
import 'package:undervoltage/utils/navigation.dart';

class LobbyState extends BaseState {
  final String matchType;
  final int numberOfPlayers;
  StreamSubscription? subscription;
  String roomId = '';

  LobbyState(this.matchType, this.numberOfPlayers);

  @override
  Future onLoad() async {
    try {
      final Room room = await const StartMatchmakingCallable()(
        playerName: LoggedUser.get.name,
        matchType: matchType,
        numberOfPlayers: numberOfPlayers,
        visibility: RoomVisibility.public,
      );

      roomId = room.id;
      notify();

      subscription = FirebaseFirestore.instance
          .collection('rooms')
          .doc(room.id)
          .snapshots()
          .listen(_onRoomChanged);
    } catch (e) {
      print(e);

      InfoDialog.error(
        text: 'Error starting matchmaking',
        onAccept: Navigation.pop,
      );
    }
  }

  @override
  void onDestroy() {
    subscription?.cancel();
  }

  void _onRoomChanged(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      final Document document = Document.load(snapshot);
      final Room room = Room.fromDocument(document);

      if (room.status == RoomStatus.closed) {
        subscription?.cancel();
        _onRoomReady(room);
      }
    }
  }

  void _onRoomReady(Room room) => Navigation.matchScreen(room);

  Future onLeave() async {
    subscription?.cancel();

    if (roomId.isNotEmpty) {
      await const StopMatchmakingCallable()(
        roomId: roomId,
      );
    }

    Navigation.pop();
  }
}
