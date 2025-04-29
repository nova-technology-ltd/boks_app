import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TvAndCableService {
  final String baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> getAllTvCable(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/cable/all-cable-tv"),
      );

      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("TV_ID")) {
          final Map<String, dynamic> electricCompany = data["TV_ID"];
          final List<Map<String, dynamic>> providers = [];
          electricCompany.forEach((key, value) {
            if (value is List) {
              providers.addAll(value.cast<Map<String, dynamic>>());
            }
          });

          return providers;
        } else {
          throw Exception(
            "Invalid data format: Expected 'ELECTRIC_COMPANY' key",
          );
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<void> subScribeCableTv({
    required BuildContext context,
    required String cableTV,
    required String packageCode,
    required String smartCardNo,
    required String phoneNo,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/cable/subscribe-cabletv"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: json.encode({
          "cableTV": cableTV,
          "packageCode": packageCode,
          "smartCardNo": smartCardNo,
          "phoneNo": phoneNo,
        })
      );
      print(cableTV);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> verifyCableTV({
    required BuildContext context,
    required String cableTV,
    required String smartCardNo
  }) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/boks/cable/verify-smartcard"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "cableTV": cableTV,
            "smartCardNo": smartCardNo,
          })
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

}
