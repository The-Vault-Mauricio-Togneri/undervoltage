import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/utils/navigation.dart';

class InfoDialog extends StatelessWidget {
  final String text;
  final VoidCallback? onAccept;

  const InfoDialog._(this.text, this.onAccept);

  static DialogController _show({
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

  static DialogController error({
    required String text,
    required VoidCallback? onAccept,
  }) =>
      _show(
        text: text,
        onAccept: onAccept,
      );

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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
