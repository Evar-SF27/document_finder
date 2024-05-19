import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finder/theme/palette.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final searchController = TextEditingController();
  var isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Palette.greyColor.withOpacity(0.05),
        ));
    return SizedBox(
      height: 50,
      child: TextField(
        controller: searchController,
        onSubmitted: (value) {
          isShowUsers = true;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            enabledBorder: textFieldBorder,
            focusedBorder: textFieldBorder,
            hintText: 'Search Places'),
      ),
    );
  }
}
