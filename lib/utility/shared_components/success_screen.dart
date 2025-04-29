import 'package:flutter/material.dart';

import 'custom_button.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String? icon;
  final String subMessage;
  final VoidCallback onClick;
  const SuccessScreen({super.key, required this.title, this.icon, required this.subMessage, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            Text(
              subMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(title: "Finish", onClick: onClick, isLoading: false),
            )
          ],
        ),
      ),
    );
  }
}
