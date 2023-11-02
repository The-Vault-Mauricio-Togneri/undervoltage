import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/label.dart';

class FaceUpCard extends StatelessWidget {
  final JsonCard card;
  final double width;
  final Function(JsonCard)? onPressed;

  const FaceUpCard({
    required this.card,
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
          color: Palette.fromCard(card),
        ),
        child: Material(
          color: Palette.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: () => onPressed?.call(card),
            child: Padding(
              padding: EdgeInsets.all(width / 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Label(
                      text: card.value.toString(),
                      color: Palette.white,
                      size: width / 2.5,
                      weight: FontWeight.bold,
                    ),
                    VBox(width / 10),
                    Label(
                      text: '±${card.diff}',
                      color: Palette.white,
                      size: width / 4,
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
