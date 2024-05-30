import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finder/models/user.dart';
import 'package:finder/utils/utils.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(db: FirebaseFirestore.instance);
});

class UserAPI {
  FirebaseFirestore db;
  UserAPI({required this.db});

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final document = await db.collection("users").doc(uid).get();
    final data = document.data();

    return data;
  }

  FutureEitherVoid saveUserData(User userModel, String uid) async {
    try {
      final user = userModel.toMap();
      await db.collection("users").doc(userModel.uid).set(user);

      return right(null);
    } on FirebaseException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occured', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
