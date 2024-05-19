import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/models/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finder/utils/utils.dart';

final documentAPIProvider = Provider((ref) {
  return DocumentAPI(db: FirebaseFirestore.instance);
});

class DocumentAPI {
  FirebaseFirestore db;
  DocumentAPI({required this.db});

  Future<List<Map<String, dynamic>>> getAllDocument(String uid) async {
    final document = await db.collection("documents").get();
    final data = document.docs;
    final documents = data.map((e) => e.data()).toList();

    return documents;
  }

  Future<Map<String, dynamic>?> getDocument(String uid) async {
    final document = await db.collection("documents").doc(uid).get();
    final data = document.data();

    return data;
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
