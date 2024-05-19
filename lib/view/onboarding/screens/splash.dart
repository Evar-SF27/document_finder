import 'package:finder/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300,
                      height: 300,
                      child: SvgPicture.asset('assets/imageee.svg')),
                  Text('Document Finder',
                      style: GoogleFonts.abel(
                          fontSize: 36,
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w900))
                ],
              ))
            ],
          )),
          SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('Built by',
                          style: GoogleFonts.abel(
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Palette.greyColor))),
                      Text('Dev Force',
                          style: GoogleFonts.abel(
                              textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.primaryColor,
                                  fontFamily: 'Helvetica'))),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
