import 'package:flutter/material.dart';
import 'package:undervoltage/app/undervoltage.dart';
import 'package:undervoltage/services/initializer.dart';

void main() async {
  await Initializer.load();
  runApp(Undervoltage(uri: Uri.base));
}
