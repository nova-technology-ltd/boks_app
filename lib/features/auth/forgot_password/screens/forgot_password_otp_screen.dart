import 'dart:async';
import 'dart:ui';

import 'package:boks/features/auth/forgot_password/screens/reset_password_screen.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_loader.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../../utility/constants/app_colors.dart';
import '../../service/auth_service.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _onOTPChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
  bool isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _verifyEmailAndSendOTP(
      BuildContext context, String email) async {
    try {
      setState(() {
        isLoading = true;
      });
      int response = await _authService.resendForgotPasswordSendOTP(context, email);
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
          _remainingSeconds = 120;
          _timer.cancel();
          startTimer();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP sent to $email")));
      }  else {
        showSnackBar(context: context, message: "Unable to send otp, please try again later", title: "Failed");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  int _remainingSeconds = 120;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String getOTP() {
    return _controllers.map((controller) => controller.text).join();
  }
  bool isOtpComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
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
              centerTitle: true,
              title: const Text(
                "OTP",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Please enter the OTP sent to",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      if (index == 3) {
                        return const Text(
                          ' - ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        );
                      }
                      int otpIndex = index > 3 ? index - 1 : index;
                      return SizedBox(
                        width: 48,
                        height: 48,
                        child: TextField(
                          controller: _controllers[otpIndex],
                          focusNode: _focusNodes[otpIndex],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 0.8,
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    width: 0.8,
                                    color: Color(AppColors.primaryColor)),
                              ),
                              filled: true,
                              fillColor: Colors.transparent
                          ),
                          onChanged: (value) {
                            _onOTPChanged(value, otpIndex);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text:  TextSpan(children: [
                    const TextSpan(
                        text: "Code expires in: ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: formatTime(_remainingSeconds),
                        style: TextStyle(
                            color: _remainingSeconds <= 10
                                ? Colors.red
                                : Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                _remainingSeconds > 0 ? const SizedBox.shrink() : TextButton(
                    onPressed: () => _verifyEmailAndSendOTP(context, widget.email),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                          color: Color(AppColors.primaryColor),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(AppColors.primaryColor)),
                    )),
                const Spacer(),
                if (isOtpComplete())
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomButton(title: "Verify", onClick: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordScreen(otp: getOTP(), email: widget.email)));
                    }, isLoading: false,),
                  ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2)
              ),
              child: const Center(
                child: CustomLoader()
              ),
            )
        ],
      ),
    );
  }
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}
