import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/apis/chat.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/chats/widgets/chat_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllChatScreen extends ConsumerStatefulWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AllChatScreen(),
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
  const AllChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends ConsumerState<AllChatScreen> {
  final chatAPI =
      ChatAPI(db: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
  var allUsers = [];
  var filteredUsers = [];
  String _search = '';
  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserProvider).value!.uid;
    final textFieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Palette.greyColor.withOpacity(0.05),
        ));

    void applySearchFilters() {
      setState(() {
        filteredUsers = allUsers.where((doc) {
          bool filterByName =
              doc.userId.toLowerCase().contains(_search.toLowerCase());

          return filterByName;
        }).toList();
        // print(filteredUsers);
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Document Finder'),
        ),
        body: Column(
          children: [
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  _search = value.toString();
                  applySearchFilters();
                },
                onSubmitted: (value) {
                  applySearchFilters();
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 235, 255)
                        .withOpacity(0.9),
                    enabledBorder: textFieldBorder,
                    focusedBorder: textFieldBorder,
                    hintText: 'Search Chats'),
              ),
            ),
            FutureBuilder(
                future: ref
                    .read(chatAPIProvider)
                    .getChatRoomsForUser(currentUserId),
                builder: (conttext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for the Future to complete
                    return const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator.adaptive());
                  } else if (snapshot.hasError) {
                    // Show an error message if the Future throws an error
                    return Text('Error(s): $snapshot');
                  } else {
                    if (allUsers.isEmpty) {
                      allUsers = snapshot.data!;
                      filteredUsers = List.from(allUsers);
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 217,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChatTile(room: filteredUsers[index]);
                          }),
                    );
                  }
                })
          ],
        ));
  }
}
