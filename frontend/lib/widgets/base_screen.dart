import 'package:flutter/material.dart';
import 'package:undervoltage/widgets/game_container.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: SafeArea(
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
    );
  }
}
