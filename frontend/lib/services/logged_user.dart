import 'package:firebase_auth/firebase_auth.dart';
import 'package:idlebattle/services/initializer.dart';

class LoggedUser {
  late User _user;

  String get id => _user.uid;

  String get name => _user.displayName ?? 'Anonymous${id.hashCode % 1000}';

  bool get isAnonymous => _user.isAnonymous;

  static LoggedUser get get => getIt<LoggedUser>();

  void load(User user) => _user = user;

  void updateName(String name) => _user.updateDisplayName(name);
}
