import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return DarkStatusBar(
      child: Scaffold(
        body: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
