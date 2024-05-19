import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finder/common/widgets/full_button.dart';
import 'package:finder/common/widgets/loading.dart';
import 'package:finder/theme/palette.dart';
import 'package:finder/view/auth/controllers/auth.dart';
import 'package:finder/view/auth/screens/register.dart';
import 'package:finder/view/auth/screens/reset.dart';
import 'package:finder/view/auth/widgets/header.dart';
import 'package:finder/view/auth/widgets/input.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginView(),
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

  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogIn() {
    ref.read(authControllerProvider.notifier).logIn(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  void redirectResetPassword() {
    Navigator.push(context, ResetPasswordView.route());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const LoadingScreen()
          : Container(
              child: Center(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: [
                          const Headline(subtitle: "Log into your account"),
                          const SizedBox(height: 50),
                          AuthField(controller: emailController, hint: 'Email'),
                          const SizedBox(height: 20),
                          AuthField(
                              controller: passwordController,
                              hint: 'Password',
                              isPassword: true),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: redirectResetPassword,
                                  child: const Text(
                                    'Forgot Password?',
                                    style:
                                        TextStyle(color: Palette.primaryColor),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                              alignment: Alignment.topRight,
                              child: ExpandedButton(
                                onPress: onLogIn,
                                text: 'Log In',
                              )),
                          const SizedBox(height: 30),
                          RichText(
                            text: TextSpan(
                                text: "Don't have an account?",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: [
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context, RegisterView.route());
                                        },
                                      text: ' Register',
                                      style: const TextStyle(
                                          color: Palette.primaryColor,
                                          fontSize: 16))
                                ]),
                          )
                        ]))),
              ),
            ),
    );
  }
}
