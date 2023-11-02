import 'package:flutter/material.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/label.dart';

class SummaryPile extends StatelessWidget {
  final int amount;
  final double width;

  const SummaryPile({
    required this.amount,
    required this.width,
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
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Palette.grey,
          ),
          child: Center(
            child: Label(
              text: amount.toString(),
              color: Palette.white,
              size: width / 3,
            ),
          ),
        ),
      ),
    );
  }
}
