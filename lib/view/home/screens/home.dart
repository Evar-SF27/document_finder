import 'package:finder/theme/palette.dart';
import 'package:finder/view/home/admin/add.dart';
import 'package:finder/view/home/admin/controllers/document.dart';
import 'package:finder/view/home/widgets/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserHomePage extends ConsumerWidget {
  final String id;
  static route(String id) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserHomePage(id: id),
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
  const UserHomePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Document Finder'),
          actions: [
            IconButton(
                icon:
                    const Icon(Icons.supervised_user_circle_rounded, size: 40),
                onPressed: () {})
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        color: Palette.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, AddDocument.route());
                      },
                      child: const Text('Report Document',
                          style: TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              ref.watch(getDocumentByHostId(id)).when(
                  data: (documents) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DocumentCard(document: documents[index]);
                          }),
                    );
                  },
                  error: (err, st) => Container(),
                  loading: () => const Text('Documents are loading'))
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.chat_bubble)));
  }
}
