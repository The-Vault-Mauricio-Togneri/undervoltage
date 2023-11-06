import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/environments/environment.dart';
import 'package:undervoltage/utils/audio.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/platform.dart';

class SetNameState extends BaseState {
  final bool isSetup;
  final TextEditingController nameController = TextEditingController();
  bool buttonEnabled = false;

  SetNameState(this.isSetup) {
    nameController.text = LoggedUser.get.name;

    if (Environment.get.isLocal && nameController.text.isEmpty) {
      nameController.text = Platform.isWeb ? 'Web' : 'Mobile';
    }

    buttonEnabled = nameController.text.isNotEmpty;
  }

  Future setName() async {
    buttonEnabled = false;
    notify();

    await LoggedUser.get.updateName(nameController.text.trim());

    if (isSetup) {
      Navigation.mainScreen();
    } else {
      Navigation.pop();
    }
  }

  void onAudioToggle() {
    Audio.get.toggle();
    notify();
  }

  void onTextChanged(String text) {
    buttonEnabled = text.trim().isNotEmpty;
    notify();
  }
}
