import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/domain/state/set_name/set_name_state.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/custom_form_field.dart';
import 'package:undervoltage/widgets/label.dart';
import 'package:undervoltage/widgets/primary_button.dart';

class SetNameScreen extends StatelessWidget {
  final SetNameState state;

  const SetNameScreen._(this.state);

  factory SetNameScreen.instance(bool isSetup) =>
      SetNameScreen._(SetNameState(isSetup));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(!state.isSetup),
      child: BaseScreen(
        child: StateProvider<SetNameState>(
          state: state,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!state.isSetup)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: Navigation.pop,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Palette.grey,
                      size: 25,
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: CustomFormField(
                  label: 'Nickname',
                  autofocus: true,
                  controller: state.nameController,
                  maxLength: 20,
                  onTextChanged: state.onTextChanged,
                ),
              ),
              const VBox(20),
              PrimaryButton(
                text: 'SAVE',
                onPressed: state.buttonEnabled ? state.setName : null,
              ),
              const Spacer(),
              Label(
                text: LoggedUser.get.id,
                color: Palette.grey,
                size: 14,
              ),
              const VBox(20),
            ],
          ),
        ),
      ),
    );
  }
}
