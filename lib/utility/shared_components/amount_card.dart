import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

class AmountCard extends StatelessWidget {
  final String price;
  final String selectedPrice;
  final VoidCallback onClick;
  const AmountCard({super.key, required this.price, required this.onClick, required this.selectedPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selectedPrice == price ? Color(AppColors.primaryColor).withOpacity(0.08) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
        ),
        child: MaterialButton(
          onPressed: onClick,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.nairaSign,
                      style: TextStyle(
                        color: Color(AppColors.primaryColor),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "${_formatPrice(double.parse(price))}",
                      style: TextStyle(
                        color: Color(AppColors.primaryColor),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }
}


class HexagonWithText extends StatelessWidget {
  final String price;
  final String selectedPrice;
  final VoidCallback onClick;
  const HexagonWithText({required this.price, required this.selectedPrice, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(80, 80),
                painter: HexagonPainter(borderColor: selectedPrice == price ? Color(AppColors.primaryColor) : Colors.transparent, backgroundColor: selectedPrice == price ? Color(AppColors.primaryColor).withOpacity(0.08) : Colors.grey.withOpacity(0.1)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.nairaSign,
                          style: TextStyle(
                            color: selectedPrice == price ? Color(AppColors.primaryColor) : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "${_formatPrice(double.parse(price))}",
                          style: TextStyle(
                            color: selectedPrice == price ? Color(AppColors.primaryColor) : Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }
}



class HexagonPainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  HexagonPainter({required this.borderColor, required this.backgroundColor});
  @override
  void paint(Canvas canvas, Size size) {
    // Paint for filling the hexagon
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Paint for the border of the hexagon
    final borderPaint = Paint()
      ..color = borderColor // Border color
      ..style = PaintingStyle.stroke // Stroke style for the border
      ..strokeWidth = 1.0; // Border width

    final path = Path();

    // Calculate the points of the hexagon
    double width = size.width;
    double height = size.height;
    double sideLength = width / 2; // Length of each side of the hexagon

    // Starting point (top center)
    path.moveTo(width / 2, 0);

    // Draw the hexagon
    path.lineTo(width, height * 0.25); // Top-right corner
    path.lineTo(width, height * 0.75); // Bottom-right corner
    path.lineTo(width / 2, height); // Bottom center
    path.lineTo(0, height * 0.75); // Bottom-left corner
    path.lineTo(0, height * 0.25); // Top-left corner
    path.close(); // Close the path to form a hexagon

    // Draw the filled hexagon
    canvas.drawPath(path, fillPaint);

    // Draw the border of the hexagon
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}