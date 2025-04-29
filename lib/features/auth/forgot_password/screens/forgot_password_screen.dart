import 'package:boks/features/auth/forgot_password/screens/forgot_password_otp_screen.dart';
import 'package:boks/features/auth/service/auth_service.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  Future<void> _sendOTP(BuildContext context, String email) async {
    try {
      setState(() {
        isLoading = true;
      });
      int response = await _authService.resetPassword(context, email);
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(email: email)));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: CustomBackButton(context: context),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("images/splash_screen_logo.png")),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Text(
                    "Please provide your registered email address to receive your reset password OTP",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 5,),
                  CustomTextField(hintText: "Email", prefixIcon: Icon(IconlyLight.message, color: Colors.grey,), isObscure: false, controller: _emailController,),
                  const SizedBox(height: 20,),
                  CustomButton(title: "Get OTP", onClick: (){
                    if (_emailController.text.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      _sendOTP(context, _emailController.text.trim());
                    } else {
                      print("Hello, World");
                    }
                  }, isLoading: isLoading ? true : false)
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
        ],
      ),
    );
  }
}
