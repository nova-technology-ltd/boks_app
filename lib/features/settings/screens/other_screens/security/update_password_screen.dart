import 'package:boks/features/settings/screens/other_screens/profile_update_success_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../utility/constants/app_icons.dart';
import '../../../../../utility/shared_components/custom_back_button.dart';
import '../../../../../utility/shared_components/custom_button.dart';
import '../../../../../utility/shared_components/custom_text_field.dart';
import '../../../../../utility/shared_components/show_snack_bar.dart';
import '../../../../../utility/shared_components/strong_password_check.dart';
import '../../../../auth/service/auth_service.dart';
import '../../../service/settings_service.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final setNewPasswordController = TextEditingController();
  final confirmSetNewPasswordController = TextEditingController();
  bool isEyeClicked = false;
  bool isLoading = false;
  final AuthService _authService = AuthService();
  SettingsService settings_service = SettingsService();

  Future<void> _updateAccountPassword(
    BuildContext context,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      int response = await settings_service.updatePassword(
        context,
        oldPassword,
        newPassword,
      );
      if (response == 200 || response == 201) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileUpdateSuccessScreen()),
        );
        await _authService.userProfile(context);
      } else {
        setState(() {
          isLoading = false;
        });
        await _authService.userProfile(context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isPasswordValid() {
    bool hasMinLength = setNewPasswordController.text.length >= 6;
    bool hasDigits = RegExp(r'\d').hasMatch(setNewPasswordController.text);
    bool hasUpperCase = RegExp(
      r'[A-Z]',
    ).hasMatch(setNewPasswordController.text);
    bool hasLowerCase = RegExp(
      r'[a-z]',
    ).hasMatch(setNewPasswordController.text);
    bool hasSymbols = RegExp(
      r'[!@#$%^&*(),.?":{}|<>]',
    ).hasMatch(setNewPasswordController.text);

    return hasMinLength &&
        hasDigits &&
        hasUpperCase &&
        hasLowerCase &&
        hasSymbols;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: CustomBackButton(context: context),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Update Password",
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
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    isObscure: isEyeClicked ? false : true,
                    controller: oldPasswordController,
                    onChange: (value) {
                      setState(() {});
                    },
                    hintText: "Enter Old Password",
                    prefixIcon: SizedBox(
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          "images/lock-outlined.png",
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isEyeClicked = !isEyeClicked;
                        });
                      },
                      icon: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          isEyeClicked
                              ? AppIcons.eyeCloseIcon
                              : AppIcons.eyeOpenIcon,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  CustomTextField(
                    isObscure: isEyeClicked ? false : true,
                    controller: setNewPasswordController,
                    onChange: (value) {
                      setState(() {});
                    },
                    hintText: "Enter New Password",
                    prefixIcon: SizedBox(
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          "images/lock-outlined.png",
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isEyeClicked = !isEyeClicked;
                        });
                      },
                      icon: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          isEyeClicked
                              ? AppIcons.eyeCloseIcon
                              : AppIcons.eyeOpenIcon,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  StrongPasswordCheck(
                    title: "6 characters and above",
                    isValid: setNewPasswordController.text.length >= 6,
                  ),
                  const SizedBox(height: 5),
                  StrongPasswordCheck(
                    title: "use of number",
                    isValid: RegExp(
                      r'\d',
                    ).hasMatch(setNewPasswordController.text),
                  ),
                  const SizedBox(height: 5),
                  StrongPasswordCheck(
                    title: "use of capital letter",
                    isValid: RegExp(
                      r'[A-Z]',
                    ).hasMatch(setNewPasswordController.text),
                  ),
                  const SizedBox(height: 5),
                  StrongPasswordCheck(
                    title: "use of small letter",
                    isValid: RegExp(
                      r'[a-z]',
                    ).hasMatch(setNewPasswordController.text),
                  ),
                  const SizedBox(height: 5),
                  StrongPasswordCheck(
                    title: "use of symbol",
                    isValid: RegExp(
                      r'[!@#$%^&*(),.?":{}|<>]',
                    ).hasMatch(setNewPasswordController.text),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    isObscure: isEyeClicked ? false : true,
                    controller: confirmSetNewPasswordController,
                    onChange: (value) {
                      setState(() {});
                    },
                    hintText: "Confirm New Password",
                    prefixIcon: SizedBox(
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          "images/lock-outlined.png",
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isEyeClicked = !isEyeClicked;
                        });
                      },
                      icon: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          isEyeClicked
                              ? AppIcons.eyeCloseIcon
                              : AppIcons.eyeOpenIcon,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    title: "Update",
                    onClick: () {
                      if (setNewPasswordController.text.trim().isNotEmpty &&
                          confirmSetNewPasswordController.text
                              .trim()
                              .isNotEmpty &&
                          oldPasswordController.text.trim().isNotEmpty &&
                          setNewPasswordController.text.trim() ==
                              confirmSetNewPasswordController.text.trim() &&
                          isPasswordValid()) {
                        _updateAccountPassword(
                          context,
                          oldPasswordController.text.trim(),
                          setNewPasswordController.text.trim(),
                        );
                      } else {
                        showSnackBar(
                          context: context,
                          message:
                              "Please make sure to provide matching passwords",
                          title: "Matching Password Required",
                        );
                      }
                    },
                    isLoading: isLoading ? true : false,
                  ),
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
