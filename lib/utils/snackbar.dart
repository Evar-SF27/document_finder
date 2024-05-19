import 'package:finder/theme/palette.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content, bool isError) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isError ? Palette.errorColor : Palette.successColor,
      content: Text(content, style: const TextStyle(fontSize: 16))));
}
