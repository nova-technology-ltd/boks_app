import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BettingService {
  final baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> allBettingServiceProvider(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/betting/all-betting-services"),
        headers: {"Content-Type": "application/json"},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        // Check if the decoded response is a List
        if (decodedResponse is List) {
          return decodedResponse.cast<Map<String, dynamic>>();
        }
        // Check if it is a Map and contains "BETTING_COMPANY"
        else if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey("BETTING_COMPANY")) {
          final dynamic bettingCompany = decodedResponse["BETTING_COMPANY"];

          if (bettingCompany is List) {
            return bettingCompany.cast<Map<String, dynamic>>();
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
      print(e);
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<String> fundBetting({
    required BuildContext context,
    required String bettingCompany,
    required String customerId,
    required String amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/betting/fund-betting"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "bettingCompany": bettingCompany,
          "customerId": customerId,
          "amount": amount,
        }),
      );
      print(response.body);
      final responseData = jsonDecode(response.body);
      return responseData['status'];
    } catch (e) {
      return "SERVER_ERROR";
    }
  }
}
