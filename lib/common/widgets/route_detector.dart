import 'package:finder/models/user.dart';
import 'package:flutter/material.dart';
import 'package:finder/view/home/screens/home.dart';

class RouteDetector extends StatelessWidget {
  final User user;
  final Widget widget;
  const RouteDetector({super.key, required this.user, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              user.role == 'user' ? HomePage.route() : HomePage.route());
        },
        child: widget);
  }
}
