import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  Widget child;

  CustomPageRoute({required this.child})
      : super(
            pageBuilder: (context, animation, secondAnimation) => child,
            transitionDuration: const Duration(seconds: 2));

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
              .animate(animation),
      child: child,
    );
  }
}
