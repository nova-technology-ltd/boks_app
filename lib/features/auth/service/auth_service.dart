import 'dart:convert';

import 'package:boks/features/home/screens/home_screen.dart';
import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/shared_components/cutom_bottom_navigation/main_panel.dart';
import '../../../utility/shared_components/http_error_handler.dart';
import '../../profile/model/user_model.dart';
import '../../profile/model/user_provider.dart';

class AuthService with ChangeNotifier {
  final String baseUrl = AppStrings.serverUrl;

  Future<int> registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String otherNames,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/auth/register-user"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "firstName": firstName,
          "lastName": lastName,
          "otherNames": otherNames,
          "phoneNumber": phoneNumber,
          "email": email,
          "password": password,
        },),
      );
      return response.statusCode;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<void> userLogin(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/auth/user-login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var responseBody = jsonDecode(response.body);
        var userJson = responseBody['user'];
        if (userJson != null) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(userJson));
          String? token = userJson['token'];
          String? boksID = userJson['boksID'];
          if (token != null && boksID != null) {
            await prefs.setString('Authorization', token);
            await prefs.setString('user', boksID);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainPanel(),
              ),
                  (route) => false,
            );
          } else {
            print("Error: token or boksID is null");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login failed. Please try again.")),
            );
          }
        } else {
          print("Error: userJson is null");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed. Please try again.")),
          );
        }
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (err) {
      print("Error during login: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Future<int> resetPassword(BuildContext context, String email) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/forgot-password"),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({"email": email}));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<int> resendForgotPasswordSendOTP(
      BuildContext context, String email) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/forgot-password"),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({"email": email}));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<UserModel?> userProfile(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");

      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/user/user-profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        var userJson = responseBody['data'];
        // Set the user in the provider


        UserModel userModel = UserModel.fromJson(jsonEncode(userJson));

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(jsonEncode(userJson));
        // Return the user model
        return userProvider.userModel;
      } else {
        // Handle HTTP error
        httpErrorHandler(
            response: response, context: context, onSuccess: () {});
        return null; // Return null in case of failure
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
        "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
      return null;
    }
  }

  Future<int> verifyOTPAndResetPassword(BuildContext context, String email,
      String otp, String newPassword) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/reset-password"),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            "email": email,
            "otp": otp,
            "newPassword": newPassword,
          }));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
        return response.statusCode;
      }
    } catch (e) {
      return -1;
    }
  }

  //verify account email
  Future<void> sendEmailVerificationOTP(
      BuildContext context, String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/send-email-verification-otp"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({"email": email}));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
      } else {
      }
    } catch (e) {

    }
  }

  Future<void> verifyEmailOTP(
      BuildContext context, String email, String otp) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/verify-email"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({"email": email, "otp": otp}));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => const EmailVerificationSuccessScreen()));
      } else {
      }
    } catch (e) {

    }
  }

  Future<void> resendEmailVerificationOTP(
      BuildContext context, String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/auth/send-email-verification-otp"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({
            "email": email,
          }));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP sent to $email")));
      } else {
      }
    } catch (e) {

    }
  }

}
