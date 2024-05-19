import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDocument extends ConsumerStatefulWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddDocument(),
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
  const AddDocument({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDocumentState();
}

class _AddDocumentState extends ConsumerState<AddDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Finder'),
        actions: [
          IconButton(
              icon: const Icon(Icons.supervised_user_circle_rounded, size: 40),
              onPressed: () {})
        ],
      ),
    );
  }
}
