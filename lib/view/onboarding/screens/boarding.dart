import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/auth/screens/login.dart';
import 'package:finder/view/home/screens/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardingScreen extends ConsumerStatefulWidget {
  const BoardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends ConsumerState<BoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserProvider);
    final isUser = user.value?.uid;
    return Scaffold(
        body: isUser == null ? const LoginView() : const EntryPage());
  }
}
