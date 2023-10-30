import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return DarkStatusBar(
      child: KeyboardDismissOnTap(
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Expanded(child: child)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
