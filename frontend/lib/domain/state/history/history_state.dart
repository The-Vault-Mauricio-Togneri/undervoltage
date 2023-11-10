import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dafluta/dafluta.dart';
import 'package:undervoltage/domain/models/document.dart';
import 'package:undervoltage/domain/models/match.dart';
import 'package:undervoltage/domain/models/user_logged.dart';

class HistoryState extends BaseState {
  List<Match>? _matches;

  bool get isLoading => _matches == null;

  List<Match> get matches => _matches!;

  @override
  Future onLoad() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('playerIds', arrayContains: LoggedUser.get.id)
        .get();

    _matches = [];

    for (final docRef in snapshot.docs) {
      final Document document = Document.load(docRef);
      _matches!.add(Match.fromDocument(document));
    }

    notify();
  }
}
