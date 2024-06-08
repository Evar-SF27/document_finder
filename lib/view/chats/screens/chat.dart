import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/apis/chat.dart';
import 'package:finder/common/widgets/loading.dart';
import 'package:finder/common/widgets/error.dart';
import 'package:finder/models/user.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/chats/controllers/chat.dart';
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
  final ChatAPI chatAPI = ChatAPI(db: FirebaseFirestore.instance);
  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await ref
          .watch(chatControllerProvider.notifier)
          .sendMessage(widget.receiver.uid, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserDetailsProvider).value!;

    Widget _buildMessageItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      var alignment = (data['senderId'] == user.value!.uid)
          ? Alignment.centerRight
          : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Column(
          children: [Text(data['senderEmail']), Text(data['message'])],
        ),
      );
    }

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
              return StreamBuilder(
                stream: chatAPI.getMessages(user!.uid, widget.receiver.uid),
                builder: (context, snapshot) {
                  print(snapshot.data!.docs);
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }
                  return ListView(
                    children: snapshot.data!.docs
                        .map((document) => Text('data'))
                        .toList(),
                  );
                },
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
                    controller: messageController,
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
                  onTap: sendMessage,
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
