// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finder/apis/auth.dart';
import 'package:finder/apis/user.dart';
import 'package:finder/models/user.dart' as user_model;
import 'package:finder/utils/utils.dart';
import 'package:finder/view/auth/screens/login.dart';
import 'package:finder/view/home/screens/home.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});

final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  final current = authController.currentUser();

  return current;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  final current = authController.getUserData(uid);

  return current;
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserProvider).value!.uid;
  final currentUser = ref.watch(userDetailsProvider(currentUserId));

  return currentUser;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI authAPI;
  final UserAPI userAPI;
  AuthController({required this.authAPI, required this.userAPI}) : super(false);

  Future<User?> currentUser() => authAPI.currentUser();

  void register(
      {required String username,
      required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await authAPI.register(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message, true), (r) async {
      user_model.User user = user_model.User(
          uid: r.user?.uid ?? '',
          firstName: username,
          lastName: '',
          role: 'user',
          email: email,
          gender: '',
          profilePhoto: '',
          contact: '');

      final new_res = await userAPI.saveUserData(user, r.user!.uid);
      new_res.fold((l) => showSnackBar(context, l.message, true), (r) {
        Navigator.push(context, LoginView.route());

        return showSnackBar(context, 'Account was created successfully', false);
      });
    });
  }

  void logIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await authAPI.login(email: email, password: password);
    state = false;

    res.fold((l) => showSnackBar(context, l.message, true), (r) {
      Navigator.push(context, HomePage.route());
      showSnackBar(context, 'User is succcessfully logged in', false);
    });
  }

  Future<user_model.User?> getUserData(String uid) async {
    final document = await userAPI.getUserData(uid);

    return document == null ? null : user_model.User.fromMap(document);
  }
}
