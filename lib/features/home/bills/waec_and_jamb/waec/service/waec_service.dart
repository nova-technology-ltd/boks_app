import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WaecService {
  final String baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> getAllWaecService(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/waec-and-jamb/waec-services"),
        headers: {
          "Content-Type": "application/json"
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("EXAM_TYPE")) {
          final List<dynamic> examTypes = data["EXAM_TYPE"];
          final List<Map<String, dynamic>> providers = examTypes
              .map((item) => item as Map<String, dynamic>)
              .toList();
          return providers;
        } else {
          throw Exception("Invalid data format: Expected 'EXAM_TYPE' key");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<void> purchaseWaecPIN(BuildContext context, String examType, String phoneNo) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/waec-and-jamb/purchase-waec-epin"), headers: {
        "Content-Type": "application/json"
      }, body: json.encode({
        "examType": examType,
        "phoneNo": phoneNo,
      }));
    } catch (e) {
      
    }
  }
}