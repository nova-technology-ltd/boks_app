import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/shared_components/custom_loader.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double? corner;
  final VoidCallback onClick;
  final bool isLoading;
  const CustomButton({super.key, required this.title, this.width, this.height, this.color, this.corner, required this.onClick, required this.isLoading, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width ?? MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? Color(AppColors.primaryColor),
        borderRadius: BorderRadius.circular(corner ?? 10)
      ),
      child: MaterialButton(onPressed: onClick, child: Center(
        child: isLoading ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 5,
              color: Colors.white,
            ),
          ),
        ) : Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 11
          ),
        ),
      ),),
    );
  }
}
