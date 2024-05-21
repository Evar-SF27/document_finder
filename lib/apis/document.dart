import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/models/document.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finder/utils/utils.dart';

final documentAPIProvider = Provider((ref) {
  return DocumentAPI(
      db: FirebaseFirestore.instance, storage: FirebaseStorage.instance);
});

class DocumentAPI {
  FirebaseFirestore db;
  FirebaseStorage storage;
  DocumentAPI({required this.db, required this.storage});

  Future<List<Map<String, dynamic>>> getAllDocument() async {
    final document = await db.collection("documents").get();
    final data = document.docs;
    final documents = data.map((e) => e.data()).toList();

    return documents;
  }

  Future<void> deleteDocument(String docId) async {
    await db.collection('documents').doc(docId).delete();
  }

  Future<Map<String, dynamic>?> getDocument(String uid) async {
    final document = await db.collection("documents").doc(uid).get();
    final data = document.data();

    return data;
  }

  Future<List<dynamic>> getDocumentByHost(String hostId) async {
    final documents =
        await db.collection("documents").where('host', isEqualTo: hostId).get();
    final data = documents.docs;

    return data;
  }

  Future<String> uploadImage(File file) async {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var name = path.substring(lastSeparator + 1, path.length);

    final ref = storage.ref().child('files/$name');
    final uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    return url;
  }

  FutureEitherVoid saveDocument(DocumentModel document) async {
    try {
      final doc = document.toMap();
      await db.collection("documents").add(doc);

      return right(null);
    } on FirebaseException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occured', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
