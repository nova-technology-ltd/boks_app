import 'dart:convert';

import 'package:boks/features/profile/model/user_model.dart';
import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  final String baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> getAllUserTransactions(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.get(Uri.parse("$baseUrl/api/v1/boks/transaction/all-transactions"), headers: {
        "Content-Type": "application",
        "Authorization": "Bearer $token"
      });
      print(response.body);
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          return decodedResponse.cast<Map<String, dynamic>>();
        }
        else if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("data")) {
          final dynamic transactions = decodedResponse["data"];

          if (transactions is List) {
            return transactions.cast<Map<String, dynamic>>();
          } else {
            throw Exception(
              "Invalid format: Expected 'BETTING_COMPANY' to be a List",
            );
          }
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, message: "Sorry, but we could not get a old on the server at the moment, please try again later. Thank You", title: "Server Error");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getAllUserRecentTransfers(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.get(Uri.parse("$baseUrl/api/v1/boks/wallet/my-recent-transfers"), headers: {
        "Content-Type": "application",
        "Authorization": "Bearer $token"
      });
      print(response.body);
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          return decodedResponse.cast<Map<String, dynamic>>();
        }
        else if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("data")) {
          final dynamic transactions = decodedResponse["data"];

          if (transactions is List) {
            return transactions.cast<Map<String, dynamic>>();
          } else {
            throw Exception(
              "",
            );
          }
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context: context, message: "Sorry, but we could not get a old on the server at the moment, please try again later. Thank You", title: "Server Error");
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> searchRecipient(BuildContext context, String query) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/wallet/search-recipient?data=$query"),
        headers: {
          "Content-Type": "application/json",
          // Add authorization if needed
          // "Authorization": "Bearer $token",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // First decode the response body
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Check if 'users' exists and is a List
        if (responseBody.containsKey('users') && responseBody['users'] is List) {
          // Cast the list to List<Map<String, dynamic>>
          List<Map<String, dynamic>> users = (responseBody['users'] as List)
              .map((userJson) => userJson as Map<String, dynamic>)
              .toList();
          return users;
        } else {
          // Handle case where 'users' field is missing or not a list
          showSnackBar(
            context: context,
            message: "Invalid response format from server",
            title: "Data Error",
          );
          return [];
        }
      } else {
        showSnackBar(
          context: context,
          message: "Failed to search recipients: ${response.statusCode}",
          title: "Search Error",
        );
        return [];
      }
    } on FormatException catch (e) {
      showSnackBar(
        context: context,
        message: "Data format error: ${e.message}",
        title: "Data Error",
      );
      return [];
    } on http.ClientException catch (e) {
      showSnackBar(
        context: context,
        message: "Network error: ${e.message}",
        title: "Network Error",
      );
      return [];
    } catch (e) {
      showSnackBar(
        context: context,
        message: "An unexpected error occurred: ${e.toString()}",
        title: "Error",
      );
      return [];
    }
  }

  Future<int> sendMoney({
    required BuildContext context,
    required recipientBoxID,
    required amount,
    required narration,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/wallet/send-money"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }, body: json.encode({
        "recipientBoxID": recipientBoxID,
        "amount": amount,
        "narration": narration,
      }));
      print(recipientBoxID);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
        return response.statusCode;
      }
    } catch (e) {
      showSnackBar(context: context, message: "Sorry, but we could not get a old on the server at the moment, please try again later. Thank You", title: "Server Error");
      return -1;
    }
  }

  Future<void> getDataBundle(BuildContext context) async {
    try {

      final requestId = DateTime.now().millisecondsSinceEpoch.toString();
      final response = await http.post(
        Uri.parse("https://api.mobilevtu.com/v1/PLbAgfHlXaNAP6NEJplGeJ6O8rT1/fetch_data_plans"),
        headers: {
          "Api-Token": "BDK5pxCNu1JbbeIdOGfAChaxXSFz",
          'Request-Id': requestId,  // Added missing header
          "content-type": "application/x-www-form-urlencoded",
        },
        body: "operator=MTN",
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Successful request
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Process your data here
          print("Data plans: ${responseData['data']}");
        } else {
          print("API returned error status");
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
      // You might want to show an error message to the user here
    }
  }
}