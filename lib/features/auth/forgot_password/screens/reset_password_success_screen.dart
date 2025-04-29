import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/material.dart';

import '../../login/screens/login_screen.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

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
            SizedBox(
              height: 200,
                width: 200,
                child: Image.asset("images/e7b7f0fa4cafde8cc25ceee3c54bf58d_3-removebg-preview.png")),
            Text(
              "Success!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              "You have successfully changed your account password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(title: "Finish", onClick: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              }, isLoading: false),
            )
          ],
        ),
      ),
    );
  }
}
