import 'dart:ffi';

import 'package:finder/common/widgets/loading.dart';
import 'package:finder/common/widgets/error.dart';
import 'package:finder/models/user.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final User receiver;
  static route(User receiver) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatScreen(receiver: receiver),
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
  const ChatScreen({super.key, required this.receiver});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final User receiver;
  late final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          foregroundColor: Palette.whiteColor,
          toolbarHeight: 70,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.receiver.firstName),
              Text(widget.receiver.email, style: const TextStyle(fontSize: 16)),
            ],
          ),
          centerTitle: false,
        ),
        body: ref.watch(currentUserProvider).when(
            data: (user) {
              return SingleChildScrollView(
                child: Column(children: [
                  Text('Hello'),
                  Text('Hello'),
                  Text('Hello'),
                  Text('Hello'),
                  Text('Hello'),
                ]),
              );
            },
            error: (error, stackTrace) => Error(error: error.toString()),
            loading: () => const Loader()),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Palette.greyColor.withOpacity(0.5), width: 1))),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 75,
                child: TextFormField(
                    // controller: widget.controller,
                    decoration: InputDecoration(
                        hintText: 'Type Message',
                        hintStyle: const TextStyle(fontSize: 18),
                        filled: true,
                        fillColor: Palette.greyColor.withOpacity(0.3),
                        contentPadding: const EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Palette.greyColor.withOpacity(0.05))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Palette.greyColor.withOpacity(0.05))))),
              ),
              const SizedBox(width: 7),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Palette.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.send,
                          color: Palette.whiteColor, size: 28)))
            ],
          ),
        ));
  }
}
