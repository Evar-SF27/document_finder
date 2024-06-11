// ignore_for_file: await_only_futures

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finder/utils/utils.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI(auth: FirebaseAuth.instance);
});

class AuthAPI {
  FirebaseAuth auth;
  AuthAPI({required this.auth});

  FutureEither<UserCredential> register(
      {required String email, required String password}) async {
    try {
      final account = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(account);
    } on FirebaseAuthException catch (e, st) {
      return left(Failure(e.toString(), st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  FutureEither<UserCredential> login(
      {required String email, required String password}) async {
    try {
      final session = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(session);
    } on FirebaseAuthException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occured', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  Future<User?> currentUser() async {
    final user = await auth.currentUser;

    return user;
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
