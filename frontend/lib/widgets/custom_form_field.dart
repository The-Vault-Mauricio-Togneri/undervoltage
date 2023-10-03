import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/palette.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputType;
  final bool canBeEmpty;
  final bool enabled;
  final bool autofocus;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final IconData? icon;
  final int? maxLength;
  final VoidCallback? onPressed;
  final VoidCallback? onIconPressed;
  final Function(String)? onTextChanged;
  final String? suffixText;

  const CustomFormField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.canBeEmpty = false,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.icon,
    this.maxLength,
    this.onPressed,
    this.onIconPressed,
    this.onTextChanged,
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
      autofocus: autofocus,
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onTextChanged,
      inputFormatters: (maxLength != null)
          ? [LengthLimitingTextInputFormatter(maxLength)]
          : null,
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
