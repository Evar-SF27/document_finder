import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finder/apis/chat.dart';
import 'package:finder/models/user.dart' as user_model;
import 'package:finder/theme/palette.dart';
// import 'package:finder/common/widgets/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finder/common/widgets/loading.dart';
import 'package:finder/view/auth/controllers/auth.dart';
// import 'package:finder/view/chats/controllers/chat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final user_model.User receiver;
  static route(user_model.User receiver) => PageRouteBuilder(
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
  final ChatAPI chatAPI =
      ChatAPI(db: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatAPI.sendMessage(messageController.text, widget.receiver.uid);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserDetailsProvider).value!;

    String formatTime(DateTime dateTime) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String hours = twoDigits(dateTime.hour);
      String minutes = twoDigits(dateTime.minute);
      return '$hours:$minutes';
    }

    Widget buildMessageItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final DateTime dt = data['dateTime'].toDate();
      final time = formatTime(dt);
      final sender = (data['sender'] == user.value!.uid);

      var alignment = sender ? Alignment.centerRight : Alignment.centerLeft;

      return SizedBox(
        width: 250,
        child: Container(
          width: 250,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
              color: sender
                  ? Palette.primaryColor
                  : Palette.blackColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10)),
          alignment: alignment,
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['message'],
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Palette.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time,
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                color: Palette.whiteColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
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
        body: Column(
          children: [
            Expanded(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height - 200,
                child: StreamBuilder(
              stream: chatAPI.getMessages(user.value!.uid, widget.receiver.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs
                      .map((document) => buildMessageItem(document))
                      .toList(),
                );
              },
            ))
          ],
        ),
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
