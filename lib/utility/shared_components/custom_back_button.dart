import 'package:boks/utility/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatefulWidget {
  final BuildContext context;
  const CustomBackButton({super.key, required this.context});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(widget.context),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Color(AppColors.primaryColor).withOpacity(0.2))
          ),
          child: Center(child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.grey,)),
        ),
      ),
    );
  }
}
