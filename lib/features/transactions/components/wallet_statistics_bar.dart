import 'package:flutter/material.dart';

class WalletStatisticsBar extends StatelessWidget {
  final Color barColor;
  final double normalizedValue; // Value between 0 and 1
  const WalletStatisticsBar({
    super.key,
    required this.barColor,
    required this.normalizedValue
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: (normalizedValue * 100).toInt(),
      child: Container(
        height: 20,
        decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }
}