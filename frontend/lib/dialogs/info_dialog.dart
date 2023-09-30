import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/navigation.dart';

class InfoDialog extends StatelessWidget {
  final String text;
  final VoidCallback? onAccept;

  const InfoDialog._(this.text, this.onAccept);

  static DialogController show({
    required String text,
    VoidCallback? onAccept,
  }) {
    final BuildContext context = Navigation.context();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => InfoDialog._(text, onAccept),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigation.pop();
              onAccept?.call();
            },
            child: Text(Localized.get.buttonOk.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
