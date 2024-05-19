import 'dart:async';

import 'package:finder/firebase_options.dart';
import 'package:finder/view/onboarding/screens/boarding.dart';
import 'package:finder/view/onboarding/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const BoardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finder',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
    );
  }
}
