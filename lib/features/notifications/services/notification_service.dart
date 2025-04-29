import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final String baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> getAllNotifications(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.get(Uri.parse("$baseUrl/api/v1/boks/notification/my-notifications"), headers: {
        "Content-Type": "application/json",
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

  Future<void> deleteUserNotifications(
      BuildContext context, List<String> notificationIDs) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");

      final response = await http.delete(
        Uri.parse("$baseUrl/api/v1/boks/notification/delete-notification"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "notificationIDs": notificationIDs,
        }),
      );

      if (response.statusCode == 200) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unable to delete notifications.")));
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: "We encountered a problem connecting to the server. Please check your internet connection or try again later.",
        title: "Server Error",
      );

    }
  }
}