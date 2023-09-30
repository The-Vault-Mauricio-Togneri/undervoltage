import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:idlebattle/build/build_version.dart';
import 'package:idlebattle/services/audio.dart';
import 'package:idlebattle/services/localizations.dart';
import 'package:idlebattle/services/logged_user.dart';
import 'package:idlebattle/widgets/custom_form_field.dart';
import 'package:idlebattle/widgets/game_container.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileState state = ProfileState();

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: StateProvider<ProfileState>(
        state: state,
        builder: (context, state) => Content(state),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final ProfileState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text('ID: ${LoggedUser.get.id}'),
        const VBox(40),
        NameFields(state),
        const VBox(40),
        AudioFields(state),
        const Spacer(),
        const Text('v$BUILD_VERSION'),
        const VBox(20),
      ],
    );
  }
}

class NameFields extends StatelessWidget {
  final ProfileState state;

  const NameFields(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.fromLTRB(constraints.maxWidth * 0.2, 0, constraints.maxWidth * 0.2, 0),
        child: Column(
          children: [
            Form(
              key: state.formKey,
              child: CustomFormField(
                label: Localized.get.inputName,
                controller: state.nameController,
                inputType: TextInputType.text,
                enabled: state.editing,
                focusNode: state.nameFocusNode,
                icon: state.editing ? Icons.check : Icons.edit,
                onIconPressed: state.onIconPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioFields extends StatelessWidget {
  final ProfileState state;

  const AudioFields(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Localized.get.inputAudio),
          const HBox(20),
          StateProvider<ProfileState>(
            state: state,
            builder: (context, state) => Switch(
              onChanged: state.onAudioSave,
              value: Audio.get.enabled,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileState extends BaseState {
  bool editing = false;

  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future onLoad() async {
    nameController.text = LoggedUser.get.name;
    notify();
  }

  void onIconPressed() {
    editing = !editing;

    if (editing) {
      nameFocusNode.requestFocus();
      nameController.selection = TextSelection(baseOffset: 0, extentOffset: nameController.text.length);
    } else {
      nameFocusNode.unfocus();
      LoggedUser.get.updateName(nameController.text.trim());
    }

    notify();
  }

  void onAudioSave(bool value) {
    Audio.get.toggle();
    notify();
  }
}
