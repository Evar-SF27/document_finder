import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finder/common/widgets/full_button.dart';
import 'package:finder/common/widgets/loading.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/auth/screens/login.dart';
import 'package:finder/view/auth/widgets/header.dart';
import 'package:finder/view/auth/widgets/input.dart';

class RegisterView extends ConsumerStatefulWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RegisterView(),
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
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onRegister() {
    ref.read(authControllerProvider.notifier).register(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const LoadingScreen()
          : Center(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: [
                        const Headline(subtitle: "Create new account"),
                        const SizedBox(height: 30),
                        AuthField(
                            controller: usernameController, hint: 'First Name'),
                        const SizedBox(height: 20),
                        AuthField(controller: emailController, hint: 'Email'),
                        const SizedBox(height: 20),
                        AuthField(
                            controller: passwordController,
                            hint: 'Password',
                            isPassword: true),
                        const SizedBox(height: 30),
                        Align(
                            alignment: Alignment.topRight,
                            child: ExpandedButton(
                                onPress: onRegister, text: 'Register')),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                              text: "Already have an account?",
                              style: const TextStyle(
                                  fontSize: 16, color: Palette.blackColor),
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context, LoginView.route());
                                      },
                                    text: ' Log In',
                                    style: const TextStyle(
                                        color: Palette.primaryColor,
                                        fontSize: 16))
                              ]),
                        )
                      ]))),
            ),
    );
  }
}
