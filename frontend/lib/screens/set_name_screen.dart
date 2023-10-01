import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/custom_form_field.dart';

class SetNameScreen extends StatelessWidget {
  final SetNameState state;

  const SetNameScreen._(this.state);

  factory SetNameScreen.instance() => SetNameScreen._(SetNameState());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<SetNameState>(
        state: state,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFormField(
                  label: 'Nickname',
                  autofocus: true,
                  controller: state.nameController,
                  onTextChanged: state.onTextChanged,
                ),
                const VBox(20),
                ElevatedButton(
                  onPressed: state.buttonEnabled ? state.setName : null,
                  child: const Text('SET NICKNAME'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SetNameState extends BaseState {
  bool buttonEnabled = false;
  final TextEditingController nameController = TextEditingController();

  Future setName() async {
    LoggedUser.get.updateName(nameController.text.trim());
    Navigation.lobbyScreen(Uri());
  }

  void onTextChanged(String text) {
    buttonEnabled = text.trim().isNotEmpty;
    notify();
  }
}
