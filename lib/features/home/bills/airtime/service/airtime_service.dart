import 'dart:convert';

import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AirtimeService {
  final baseUrl = AppStrings.serverUrl;

  Future<String> buyAirtime(BuildContext context, String mobileNetwork, String amount, String mobileNumber, String bonusType) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/airtime/buy-airtime"),
        headers: {
        "Content-Type": "application/json",
          "Authorization": "Bearer $token"
      },
        body: json.encode({
          "mobileNetwork": mobileNetwork,
          "amount": amount,
          "mobileNumber": mobileNumber,
          "bonusType": bonusType,
        })
      );
      print(response.body);
      print(response.statusCode);
      final responseData = jsonDecode(response.body);
      return responseData['orderstatus'];
    } catch (e) {
      print(e);
      return 'SERVER_ERROR';
    }
  }

  Future<int> buyAirtimeTwo(
      {required BuildContext context, required String serviceID, required String amount, required String phone}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/boks/airtime/buy-airtime-two"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "serviceID": serviceID,
          "phone": phone,
          "amount": amount,
        }),
      );
      print(response.body);
      print(response.statusCode);
      final responseData = jsonDecode(response.body);
      return responseData['code'];
    } catch (e) {
      print(e);
      return -1;
    }
  }

}