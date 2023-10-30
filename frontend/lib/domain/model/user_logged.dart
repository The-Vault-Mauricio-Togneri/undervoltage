import 'package:firebase_auth/firebase_auth.dart';
import 'package:tensionpath/utils/locator.dart';

class LoggedUser {
  late User _user;

  String get id => _user.uid;

  String get name => _user.displayName ?? '';

  bool get isAnonymous => _user.isAnonymous;

  bool get hasName => _user.displayName?.isNotEmpty ?? false;

  static LoggedUser get get => locator<LoggedUser>();

  void load(User user) => _user = user;

  Future _reload() async {
    await _user.reload();
    load(FirebaseAuth.instance.currentUser!);
  }

  Future updateName(String name) async {
    await _user.updateDisplayName(name);
    await _reload();
  }
}
