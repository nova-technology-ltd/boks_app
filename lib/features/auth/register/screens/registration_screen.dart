import 'package:boks/features/auth/register/screens/registration_success_screen.dart';
import 'package:boks/features/auth/service/auth_service.dart';
import 'package:boks/utility/shared_components/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../utility/constants/app_colors.dart';
import '../../../../utility/shared_components/custom_button.dart';
import '../../../../utility/shared_components/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _otherNamesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  bool isChecked = false;
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> _registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String otherNames,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      int response = await _authService.registerUser(
        context: context,
        firstName: firstName,
        lastName: lastName,
        otherNames: otherNames,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RegistrationSuccessScreen(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
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
              leading: CustomBackButton(context: context),
              centerTitle: true,
              title: const Text(
                "Create Account",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("images/splash_screen_logo.png"),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    // SizedBox(
                    //     height: 100,
                    //     width: 100,
                    //     child: Image.asset("images/e7b7f0fa4cafde8cc25ceee3c54bf58d_2-removebg-preview.png")),
                    // const SizedBox(height: 25,),
                    CustomTextField(
                      hintText: "First Name",
                      prefixIcon: Icon(IconlyLight.profile, color: Colors.grey),
                      isObscure: false,
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Last Name",
                      prefixIcon: Icon(IconlyLight.profile, color: Colors.grey),
                      isObscure: false,
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Other Names (optional)",
                      prefixIcon: Icon(IconlyLight.profile, color: Colors.grey),
                      isObscure: false,
                      controller: _otherNamesController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Email",
                      prefixIcon: Icon(IconlyLight.message, color: Colors.grey),
                      isObscure: false,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Phone Number",
                      prefixIcon: Icon(IconlyLight.call, color: Colors.grey),
                      isObscure: false,
                      controller: _phoneNumberController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Password",
                      prefixIcon: Icon(IconlyLight.lock, color: Colors.grey),
                      isObscure: isObscure,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure
                              ? Icons.remove_red_eye_rounded
                              : Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color:
                                      isChecked
                                          ? Color(AppColors.primaryColor)
                                          : Colors.grey,
                                ),
                              ),
                              child:
                                  isChecked
                                      ? Center(
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                            color: Color(
                                              AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "I agree to the terms & condition",
                            style: TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: "Register",
                      onClick: () {
                        FocusScope.of(context).unfocus();
                        if (_firstNameController.text.trim().isNotEmpty &&
                            _lastNameController.text.trim().isNotEmpty &&
                            _emailController.text.trim().isNotEmpty &&
                            _phoneNumberController.text.trim().isNotEmpty &&
                            _passwordController.text.trim().isNotEmpty &&
                            isChecked) {
                          _registerUser(
                            context: context,
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            otherNames: _otherNamesController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        } else {
                          print("Please provide your information");
                        }
                      },
                      isLoading: isLoading ? true : false,
                    ),
                  ],
                ),
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
