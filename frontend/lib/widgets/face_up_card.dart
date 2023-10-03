import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/widgets/label.dart';

class FaceUpCard extends StatelessWidget {
  final JsonCard card;
  final Function(JsonCard)? onPressed;

  const FaceUpCard({
    required this.card,
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
          color: Palette.fromCard(card),
        ),
        child: Material(
          color: Palette.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: () => onPressed?.call(card),
            child: Padding(
              padding: EdgeInsets.all(cardWidth / 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Label(
                      text: card.value.toString(),
                      color: Palette.white,
                      size: cardWidth / 2.5,
                      weight: FontWeight.bold,
                    ),
                    VBox(cardWidth / 10),
                    Label(
                      text: '±${card.diff}',
                      color: Palette.white,
                      size: cardWidth / 4,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
