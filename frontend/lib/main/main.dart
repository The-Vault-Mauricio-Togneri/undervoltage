import 'package:flutter/material.dart';
import 'package:idlebattle/app/idle_battle.dart';
import 'package:idlebattle/services/initializer.dart';

void main() async {
  await Initializer.load();
  runApp(IdleBattleApp(uri: Uri.base));
}
