import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String error;
  const Error({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Error(error: error),
    );
  }
}
