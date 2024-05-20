// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:finder/apis/document.dart';
import 'package:finder/models/document.dart';
import 'package:finder/view/home/screens/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finder/utils/utils.dart';

final documentControllerProvider =
    StateNotifierProvider<DocumentController, bool>((ref) {
  return DocumentController(documentAPI: ref.watch(documentAPIProvider));
});

final uploadDocumentImageProvider = FutureProvider.family((ref, File file) {
  return ref.watch(documentControllerProvider.notifier).uploadImage(file);
});

final getDocumentById = FutureProvider.family((ref, String uid) {
  return ref.watch(documentControllerProvider.notifier).getDocumentById(uid);
});

final getDocumentByHostId = FutureProvider.family((ref, String hostId) {
  return ref
      .watch(documentControllerProvider.notifier)
      .getDocumentByHostId(hostId);
});

final getAllDocuments = FutureProvider((ref) {
  return ref.watch(documentControllerProvider.notifier).getDocuments();
});

class DocumentController extends StateNotifier<bool> {
  final DocumentAPI documentAPI;
  DocumentController({required this.documentAPI}) : super(false);

  Future<String> uploadImage(File file) {
    return documentAPI.uploadImage(file);
  }

  Future<DocumentModel?> getDocumentById(String uid) async {
    final docs = await documentAPI.getDocument(uid);
    final document = docs == null ? null : DocumentModel.fromMap(docs);

    return document;
  }

  Future<List<DocumentModel>> getDocumentByHostId(String hostId) async {
    final data = await documentAPI.getDocumentByHost(hostId);
    final document = data.map((e) => DocumentModel.fromMap(e.data())).toList();

    return document;
  }

  Future<List<DocumentModel>> getDocuments() async {
    final docs = await documentAPI.getAllDocument();
    final documents = docs.map((e) => DocumentModel.fromMap(e)).toList();

    return documents;
  }

  void postDocument(
      {required String name,
      required String type,
      required String host,
      required List<String> images,
      required String location,
      required DateTime foundAt,
      required BuildContext context}) async {
    state = true;

    DocumentModel doc = DocumentModel(
        name: name,
        type: type,
        images: images,
        foundAt: foundAt,
        host: host,
        location: location);

    final new_res = await documentAPI.saveDocument(doc);
    new_res.fold((l) => showSnackBar(context, l.message, true), (r) {
      Navigator.pop(context);

      return showSnackBar(context, 'Document was added successfully', false);
    });

    state = false;
  }
}
