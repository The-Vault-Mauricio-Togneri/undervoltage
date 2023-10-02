import 'package:flutter/material.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/services/palette.dart';

class FaceDownPile extends StatelessWidget {
  final List<JsonCard> cards;
  final VoidCallback? onPressed;

  const FaceDownPile({
    required this.cards,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 104) / 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 0.5,
          color: Palette.grey,
        ),
      ),
      child: Container(
        width: cardWidth,
        height: cardWidth * 1.56,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: cardWidth / 15,
            color: Palette.white,
          ),
          color: Palette.grey,
        ),
        child: Material(
          color: Palette.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
