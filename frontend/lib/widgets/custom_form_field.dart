import 'package:flutter/material.dart';
import 'package:idlebattle/services/localizations.dart';
import 'package:idlebattle/services/palette.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputType;
  final bool canBeEmpty;
  final bool enabled;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onIconPressed;
  final String? suffixText;

  const CustomFormField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.canBeEmpty = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.icon,
    this.onPressed,
    this.onIconPressed,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      controller: controller,
      readOnly: !enabled,
      onTap: onPressed,
      obscureText: isPassword,
      keyboardType: inputType,
      focusNode: focusNode,
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
        suffixIcon: (icon != null)
            ? IconButton(
                onPressed: onIconPressed,
                icon: Icon(
                  icon!,
                  color: enabled ? Colors.green : Colors.grey,
                ),
              )
            : null,
        counterText: '',
        counterStyle: const TextStyle(fontSize: 0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.grey, width: 1),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.grey, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.grey, width: 1),
        ),
      ),
      validator: (value) {
        if (!canBeEmpty && (value == null || value.isEmpty)) {
          return Localized.get.fieldCantBeEmpty(label);
        }
        return null;
      },
    );
  }
}
