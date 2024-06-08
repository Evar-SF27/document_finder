import 'package:finder/theme/palette.dart';
import 'package:finder/view/home/admin/controllers/document.dart';
import 'package:finder/view/home/widgets/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomePage extends ConsumerStatefulWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const UserHomePage(),
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
  const UserHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserHomePageState();
}

class _UserHomePageState extends ConsumerState<UserHomePage> {
  var allDocuments = [];
  var filteredDocuments = [];
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Palette.greyColor.withOpacity(0.05),
        ));

    void applySearchFilters() {
      setState(() {
        filteredDocuments = allDocuments.where((doc) {
          bool filterByName =
              doc.name.toLowerCase().contains(_search.toLowerCase());

          return filterByName;
        }).toList();
        // print(filteredDocuments);
      });
    }

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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(children: [
            SizedBox(
              height: 60,
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
                    hintText: 'Search Places'),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Reported Documents',
                  style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 24)))
            ]),
            FutureBuilder(
                future: ref
                    .read(documentControllerProvider.notifier)
                    .getDocuments(),
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
                    if (allDocuments.isEmpty) {
                      allDocuments = snapshot.data!;
                      filteredDocuments = List.from(allDocuments);
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 217,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredDocuments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DocumentCard(
                                document: filteredDocuments[index]);
                          }),
                    );
                  }
                })
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.chat_bubble)));
  }
}
