import 'package:boks/features/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:boks/features/auth/service/auth_service.dart';
import 'package:boks/features/home/screens/home_screen.dart';
import 'package:boks/utility/constants/app_colors.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../register/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isObscure = true;
  bool isChecked = false;
  bool isLoading = false;

  Future<void> _loadSavedCredentials() async {
    try {
      // Check if "Remember Me" was enabled
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('rememberMe') ?? false;

      if (rememberMe) {
        final email = await _secureStorage.read(key: 'email');
        final password = await _secureStorage.read(key: 'password');

        if (email != null && password != null) {
          setState(() {
            _emailController.text = email;
            _passwordController.text = password;
            isChecked = true;
          });
        }
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', isChecked);

      if (isChecked) {
        await _secureStorage.write(
          key: 'email',
          value: _emailController.text.trim(),
        );
        await _secureStorage.write(
          key: 'password',
          value: _passwordController.text.trim(),
        );
      } else {
        await _secureStorage.delete(key: 'email');
        await _secureStorage.delete(key: 'password');
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  Future<void> _userLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _authService.userLogin(context, email, password);
      await _saveCredentials();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadSavedCredentials();
    super.initState();
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
            ),
            body: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            "images/e7b7f0fa4cafde8cc25ceee3c54bf58d_2-removebg-preview.png",
                          ),
                        ),
                        const SizedBox(height: 25),
                        CustomTextField(
                          hintText: "Email",
                          prefixIcon: Icon(
                            IconlyLight.message,
                            color: Colors.grey,
                          ),
                          isObscure: false,
                          controller: _emailController,
                          autofillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "Password",
                          prefixIcon: Icon(
                            IconlyLight.lock,
                            color: Colors.grey,
                          ),
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
                          autofillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                                  ? Color(
                                                    AppColors.primaryColor,
                                                  )
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
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                    "Remember Me",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          title: "Login",
                          onClick: () {
                            FocusScope.of(context).unfocus();
                            if (_emailController.text.trim().isNotEmpty &&
                                _passwordController.text.trim().isNotEmpty) {
                              _userLogin(
                                context: context,
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            } else {
                              print("Login info required");
                            }
                          },
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account yet? ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: "SignUp",
                                  style: TextStyle(
                                    color: Color(AppColors.primaryColor),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
