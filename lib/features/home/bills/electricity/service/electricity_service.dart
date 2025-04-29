import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ElectricityService {
  final baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> allElectricityServiceProvider(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/boks/electricity/all-electricity-services"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("ELECTRIC_COMPANY")) {
          final Map<String, dynamic> electricCompany = data["ELECTRIC_COMPANY"];
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

  Future<int> verifyMeterCardNumber(
    BuildContext context,
    electricCompany,
    meterNo,
  ) async {
    try {
      final Map<String, String> queryParams = {
        'electricCompany': electricCompany,
        'meterNo': meterNo,
      };

      final response = await http.get(
        Uri.parse(
          "$baseUrl/api/v1/boks/electricity/verify-meter",
        ).replace(queryParameters: queryParams),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response: $responseData');
        return response.statusCode;
      } else {
        print(
          'Failed to verify meter number. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<String> payElectricityBill({
    required BuildContext context,
    required String electricCompany,
    required String meterType,
    required String meterNo,
    required String amount,
    required String phoneNo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/electricity/pay-electricity"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      final responseData = jsonDecode(response.body);
      return responseData['status'];
    } catch (e) {
      showSnackBar(
        context: context,
        message:
            "Sorry, but we are unable to get a hold on the server at te moment, please try again later. Thank You",
        title: "Server Error",
      );
      return "SERVER_ERROR";
    }
  }
}
