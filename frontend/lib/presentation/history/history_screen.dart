import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/domain/state/history/history_state.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryState state;

  const HistoryScreen._(this.state);

  factory HistoryScreen.instance() => HistoryScreen._(HistoryState());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<HistoryState>(
        state: state,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Label(
              text: LoggedUser.get.id,
              color: Palette.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
