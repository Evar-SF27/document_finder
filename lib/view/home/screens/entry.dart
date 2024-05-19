import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/home/screens/admin.dart';
import 'package:finder/view/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryPage extends ConsumerWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EntryPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDoc = ref.watch(currentUserDetailsProvider).value;
    final role = userDoc!.value?.role;

    return role == 'user' ? const UserHomePage() : const AdminHomePage();
  }
}
