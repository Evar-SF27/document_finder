import 'dart:io';

import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/home/admin/controllers/document.dart';
import 'package:finder/view/onboarding/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedType = 'ID';
  DateTime _selectedDate = DateTime.now();
  List<File> _pictures = [];

  final List<String> _types = ['ID', 'Passport', 'Random', 'Birth Cert'];

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pictures.add(File(image.path));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void sharePost() {
    final user = ref.read(currentUserDetailsProvider).value;
    final userId = user!.value?.uid;

    final imgUrls = _pictures
        .map((file) => ref.watch(uploadDocumentImageProvider(file)).value!)
        .toList();

    ref.read(documentControllerProvider.notifier).postDocument(
        name: _nameController.text,
        type: _selectedType,
        host: userId!,
        images: imgUrls,
        location: _locationController.text,
        foundAt: _selectedDate,
        context: context);
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Report Document',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor)),
                // Name Field
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Name on Document',
                      hintStyle: const TextStyle(fontSize: 18),
                      filled: true,
                      fillColor: Palette.greyColor.withOpacity(0.1),
                      contentPadding: const EdgeInsets.all(22)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name on the document';
                    }
                    return null;
                  },
                ),
                // Type Dropdown Field
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: _types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                      hintText: 'Type',
                      hintStyle: const TextStyle(fontSize: 18),
                      filled: true,
                      fillColor: Palette.greyColor.withOpacity(0.1),
                      contentPadding: const EdgeInsets.all(22)),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                // Date Picker Field
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                      "Date Picked: ${_selectedDate.toLocal()}".split(' ')[0]),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: _pickDate,
                ),

                // Location Field
                const SizedBox(height: 20),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                      hintText: 'Location',
                      hintStyle: const TextStyle(fontSize: 18),
                      filled: true,
                      fillColor: Palette.greyColor.withOpacity(0.1),
                      contentPadding: const EdgeInsets.all(22)),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                // Pictures Field
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Pictures', style: TextStyle(fontSize: 16)),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _pictures
                          .map((image) =>
                              Image.file(image, width: 100, height: 100))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Add Picture',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form Submitted')),
                      );
                    }
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
