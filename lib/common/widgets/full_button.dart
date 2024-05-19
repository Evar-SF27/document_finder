import 'package:flutter/material.dart';
import 'package:finder/theme/palette.dart';

class ExpandedButton extends StatelessWidget {
  final String text;
  final Color btnColor;
  final Color textColor;
  final VoidCallback onPress;
  const ExpandedButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.textColor = Palette.whiteColor,
      this.btnColor = Palette.primaryColor});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: onPress,
        child: Container(
            width: width - 20,
            height: 60,
            decoration: BoxDecoration(
                color: btnColor, borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ))));
  }
}
