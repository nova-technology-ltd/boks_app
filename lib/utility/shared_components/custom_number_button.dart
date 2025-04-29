import 'package:flutter/material.dart';

class CustomNumberButton extends StatelessWidget {
  final VoidCallback onClick;
  final int numbers;
  const CustomNumberButton({super.key, required this.onClick, required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: 50,
        width: 100,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: MaterialButton(
            onPressed: onClick,
            child: Center(
              child: Text(
                numbers.toString(),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}