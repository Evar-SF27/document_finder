import 'package:flutter/material.dart';
import 'package:finder/theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class Headline extends StatelessWidget {
  final String subtitle;
  const Headline({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Document Finder',
            style: GoogleFonts.abel(
                fontSize: 36,
                color: Palette.primaryColor,
                fontWeight: FontWeight.w900)),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.primaryColor))
      ],
    );
  }
}
