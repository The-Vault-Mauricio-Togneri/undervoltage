import 'package:flutter/material.dart';
import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/utils/palette.dart';

class FaceDownPile extends StatelessWidget {
  final List<JsonCard> cards;
  final double width;
  final VoidCallback? onPressed;

  const FaceDownPile({
    required this.cards,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 0.5,
          color: Palette.grey,
        ),
      ),
      child: Container(
        width: width,
        height: width * 1.56,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: width / 15,
            color: Palette.white,
          ),
        ),
        child: Material(
          color: Palette.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: onPressed,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
