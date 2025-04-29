import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../utility/constants/app_colors.dart';

class EmailVerificationSuccessScreen extends StatelessWidget {
  const EmailVerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: const Color(AppColors.primaryColor).withOpacity(0.4),
                  shape: BoxShape.circle
              ),
              child: const Center(child: Icon(Icons.check, color: Colors.white, size: 25,)),
            ),
            const SizedBox(height: 10,),
            const Text(
              "Email Verified Successfully",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            const Text(
              "You have successfully verified you email",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey
              ),
            ),
            const Spacer(),
            CustomButton(title: "Done", onClick: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, isLoading: false,)
          ],
        ),
      ),
    );
  }
}
