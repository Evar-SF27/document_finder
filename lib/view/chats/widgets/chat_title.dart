import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/chats/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTile extends ConsumerStatefulWidget {
  final dynamic room;
  const ChatTile({super.key, required this.room});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTileState();
}

class _ChatTileState extends ConsumerState<ChatTile> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value!.uid;
    final chat = widget.room;
    final otherUser =
        chat.currentId == currentUser ? chat.userId : chat.currentId;
    return GestureDetector(
        onTap: () {
          ref.watch(userDetailsProvider(otherUser)).when(
              data: (user) {
                Navigator.push(context, ChatScreen.route(user!));
              },
              error: (err, st) => Container(),
              loading: () => Container());
        },
        child: ref.watch(userDetailsProvider(otherUser)).when(
            data: (user) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Palette.primaryColor.withOpacity(0.2)))),
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Palette.primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(user!.email[0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Palette.whiteColor)),
                          ],
                        )),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(user.firstName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Palette.primaryColor)),
                        Text(user.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Palette.blackColor)),
                      ],
                    )
                  ],
                ),
              );
            },
            error: (e, st) => Container(),
            loading: () => Container()));
  }
}
