import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;

  const AppText(
      {super.key,
      this.size = 16,
      required this.text,
      this.color = Colors.black,
      this.weight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    final counterTextStyle = GoogleFonts.montserrat(
        fontStyle: FontStyle.normal,
        fontSize: size,
        fontWeight: weight,
        color: color);
    return Text(text, style: counterTextStyle);
  }
}
