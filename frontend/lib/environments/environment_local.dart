import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:undervoltage/environments/environment.dart';

class LocalEnvironment extends Environment {
  @override
  String get name => 'local';

  @override
  Future configure() async {
    await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
    FirebaseDatabase.instance.useDatabaseEmulator('10.0.2.2', 9000);
  }
}
