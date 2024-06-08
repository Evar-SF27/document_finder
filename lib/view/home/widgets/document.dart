import 'package:finder/models/document.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/chats/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class DocumentCard extends ConsumerStatefulWidget {
  final DocumentModel document;
  final bool isAdmin;
  const DocumentCard({super.key, required this.document, this.isAdmin = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentCardState();
}

class _DocumentCardState extends ConsumerState<DocumentCard> {
  @override
  Widget build(BuildContext context) {
    final name = widget.document.name;
    final type = widget.document.type;
    final hostId = widget.document.host;
    final location = widget.document.location;
    final date = timeago.format(DateTime.fromMillisecondsSinceEpoch(
        widget.document.foundAt.millisecondsSinceEpoch));
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      // height: 500,
      decoration: BoxDecoration(
          // color: Colors.grey.withOpacity(0.1),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 250, 235, 255),
                Palette.whiteColor,
                Color.fromARGB(255, 250, 235, 255),
              ]),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              Text('Name on Document: ',
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              Text(name,
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)))
            ],
          ),
          Row(
            children: [
              Text('Document Type: ',
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              Text(type,
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)))
            ],
          ),
          Row(
            children: [
              Text('Date Reported: ',
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              Text(date,
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)))
            ],
          ),
          Container(
            // width: 300,
            height: 300,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.document.images[0]))),
          ),
          Row(
            children: [
              Text('Location: ',
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              Text(location,
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)))
            ],
          ),
          if (widget.isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      // ref.read(deleteDocumentById(widget.document));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Palette.errorColor),
                        child: const Text('Delete',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.whiteColor,
                                fontSize: 14))))
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      ref.watch(userDetailsProvider(hostId)).when(
                          data: (user) {
                            Navigator.push(context, ChatScreen.route(user!));
                          },
                          error: (err, st) => Container(),
                          loading: () => Container());
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Palette.primaryColor),
                        child: const Row(
                          children: [
                            Text('Message',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.whiteColor,
                                    fontSize: 16)),
                            SizedBox(width: 10),
                            Icon(Icons.send,
                                size: 18, color: Palette.whiteColor)
                          ],
                        )))
              ],
            )
        ],
      ),
    );
  }
}
