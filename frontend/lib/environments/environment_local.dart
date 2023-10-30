import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tensionpath/environments/environment.dart';

class LocalEnvironment extends Environment {
  @override
  String get name => 'local';

  @override
  String get matchServerUrl => 'ws://$host:3000';

  @override
  Future configure() async {
    FirebaseAuth.instance.useAuthEmulator(Environment.get.host, 9099);

    FirebaseFirestore.instance.settings = Settings(
      host: '${Environment.get.host}:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(Environment.get.host, 8080);

    await FirebaseStorage.instance
        .useStorageEmulator(Environment.get.host, 9199);
  }
}
