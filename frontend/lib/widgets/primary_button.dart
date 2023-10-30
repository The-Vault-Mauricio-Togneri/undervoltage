import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionpath/utils/palette.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Palette.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
        ),
        onPressed: onPressed,
        child: (icon != null)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon!,
                    size: 18,
                    color: Palette.white,
                  ),
                  const HBox(10),
                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }
}
