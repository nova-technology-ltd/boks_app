import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/shared_components/http_error_handler.dart';
import '../../../utility/shared_components/show_snack_bar.dart';
import '../../profile/model/user_model.dart';

class SettingsService {
  final String baseUrl = AppStrings.serverUrl;





  Future<int> checkIfKoradTagAlreadyExists(BuildContext context, String koradTag) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("Authorization");

      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/wishlist/find-users"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "koradTAG": "@$koradTag",
        }),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Found");
        return response.statusCode;
      } else {
        print("Not Found");
        return response.statusCode;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<void> writeUsASoftwareReview(BuildContext context, String title, String message, String stars) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/user/review-software"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }, body: json.encode({
        "title": title,
        "message": message,
        "stars": stars,
      }));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
        "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
  }

  Future<Map<String, dynamic>?> mySoftwareReview(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");

      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/user/my-software-review"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['data'] is List && responseBody['data'].isNotEmpty) {
          final List<dynamic> dataList = responseBody['data'];
          return dataList[0];
        }
        return null; // If `data` is empty, return null
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(
          context: context,
          message: responseData['message'],
          title: responseData['title'],
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
        "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
    return null;
  }

  Future<void> updateUserSoftwareReview(BuildContext context, String title, String message, String stars, String SRID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.put(Uri.parse("$baseUrl/api/v1/boks/user/update-user-software-review"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }, body: json.encode({
        "SRID": SRID,
        "title": title,
        "message": message,
        "stars": stars,
      }));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
        "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
  }

  Future<void> clearUserSoftwareReview(BuildContext context, String SRID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.delete(Uri.parse("$baseUrl/api/v1/boks/user/clear-software-review/user"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }, body: json.encode({
        "SRID": SRID,
      }));
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message:
        "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
  }

  Future<void> generateInviteCode(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/user/new-invite-code"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (e) {
      showSnackBar(context: context, message: "Sorry, but we were unable to get a hold of the server at the moment please try again later. Thank You", title: "Server Error");
    }
  }

  Future<List<UserModel>> getAllUserInvites(BuildContext context) async {
    List<UserModel> invites = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.get(Uri.parse("$baseUrl/api/v1/boks/user/user-invites"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = jsonDecode(response.body)['invites'];
        for (var categoryData in responseData) {
          invites.add(UserModel.fromMap(categoryData));
        }
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      showSnackBar(context: context, message: "Sorry, we were unable to get a hold of the server at this moment, please try again later. Thank You.", title: "Server Error");
    }
    return invites;
  }

  Future<void> updateProfile(
      BuildContext context, Map<String, dynamic> updates) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final Uri url =
      Uri.parse("$baseUrl/api/v1/boks/user/update-user-profile");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updates),
      );
      httpErrorHandler(
          response: response,
          context: context,
          onSuccess: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => const ProfileUpdateSuccessScreen()));
          });
    } catch (error) {
      showSnackBar(
        context: context,
        message: "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
  }

  Future<void> uploadProfileImage(
      BuildContext context, Map<String, dynamic> updates) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final Uri url =
      Uri.parse("$baseUrl/api/v1/boks/user/update-user-profile");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updates),
      );
    } catch (error) {
      showSnackBar(
        context: context,
        message: "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
    }
  }

  Future<int> updatePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final Uri url =
      Uri.parse("$baseUrl/api/v1/boks/user/update-user-password");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
        return response.statusCode;
      }
    } catch (error) {
      showSnackBar(
        context: context,
        message: "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );
      return -1;

    }
  }

  Future<int> setAccountPIN(BuildContext context, int accountPIN) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.put(
          Uri.parse("$baseUrl/api/v1/boks/user/set-user-account-pin"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({"transactionPIN": accountPIN}));
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
        return response.statusCode;
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );

      return -1;

    }
  }


}