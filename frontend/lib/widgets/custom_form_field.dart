import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionpath/utils/palette.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final Function(String)? onTextChanged;

  const CustomFormField({
    required this.label,
    required this.controller,
    this.inputType = TextInputType.text,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !enabled,
      keyboardType: inputType,
      autofocus: autofocus,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onTextChanged,
      inputFormatters: (maxLength != null)
          ? [LengthLimitingTextInputFormatter(maxLength)]
          : null,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }
}
