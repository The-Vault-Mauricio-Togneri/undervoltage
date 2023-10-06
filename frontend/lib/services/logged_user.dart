import 'package:firebase_auth/firebase_auth.dart';
import 'package:undervoltage/services/locator.dart';

class LoggedUser {
  late User _user;

  String get id => _user.uid;

  String get name => _user.displayName ?? '';

  bool get isAnonymous => _user.isAnonymous;

  bool get hasName => _user.displayName?.isNotEmpty ?? false;

  static LoggedUser get get => locator<LoggedUser>();

  void load(User user) => _user = user;

  Future updateName(String name) async {
    _user.updateDisplayName(name);
    await _user.reload();
    load(FirebaseAuth.instance.currentUser!);
  }
}
