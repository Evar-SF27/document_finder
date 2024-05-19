import 'package:flutter/material.dart';
import 'package:finder/theme/palette.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const InputField({super.key, required this.controller, required this.hint});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  var hidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 18),
            filled: true,
            fillColor: Palette.greyColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.all(22),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Palette.primaryColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: Palette.greyColor.withOpacity(0.05)))));
  }
}
