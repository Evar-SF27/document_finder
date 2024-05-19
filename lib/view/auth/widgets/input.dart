import 'package:flutter/material.dart';
import 'package:finder/theme/palette.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  const AuthField(
      {super.key,
      required this.controller,
      required this.hint,
      this.isPassword = false});

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  var hidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        obscureText: !widget.isPassword ? false : hidden,
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 18),
            filled: true,
            contentPadding: const EdgeInsets.all(22),
            suffixIcon: widget.isPassword
                ? (hidden
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            hidden = false;
                          });
                        },
                        icon: const Icon(Icons.visibility_off))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            hidden = true;
                          });
                        },
                        icon: const Icon(Icons.visibility)))
                : null,
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
