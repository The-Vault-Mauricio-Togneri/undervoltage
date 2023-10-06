import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/custom_form_field.dart';

class SetNameScreen extends StatelessWidget {
  final SetNameState state;

  const SetNameScreen._(this.state);

  factory SetNameScreen.instance(Uri uri) => SetNameScreen._(SetNameState(uri));

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
                  maxLength: 20,
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
  final Uri uri;
  bool buttonEnabled = false;
  final TextEditingController nameController = TextEditingController();

  SetNameState(this.uri) {
    nameController.text = LoggedUser.get.name;
  }

  void setName() {
    LoggedUser.get.updateName(nameController.text.trim());
    Navigation.lobbyScreen(uri);
  }

  void onTextChanged(String text) {
    buttonEnabled = text.trim().isNotEmpty;
    notify();
  }
}
