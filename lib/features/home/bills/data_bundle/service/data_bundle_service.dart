import 'dart:convert';
import 'package:boks/utility/constants/app_strings.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBundleService {
  final String baseUrl = AppStrings.serverUrl;

  Future<List<Map<String, dynamic>>> getAllDataBundles(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/boks/data-bundle/data-bundle-plans"), headers: {
        "Content-Type": "application/json"
      });
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("MOBILE_NETWORK")) {
          final Map<String, dynamic> electricCompany = data["MOBILE_NETWORK"];
          final List<Map<String, dynamic>> providers = [];
          electricCompany.forEach((key, value) {
            if (value is List) {
              providers.addAll(value.cast<Map<String, dynamic>>());
            }
          });

          return providers;
        } else {
          throw Exception("Invalid data format: Expected 'ELECTRIC_COMPANY' key");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllDataBundlesTwo(BuildContext context, String planName) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/api/v1/boks/data-bundle/all-data-plans?service=$planName"),
          headers: {"Content-Type": "application/json"}
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey("plans") && data["plans"] is Map) {
          final Map<String, dynamic> plansData = data["plans"];

          if (plansData.containsKey("plans") && plansData["plans"] is List) {
            final List<dynamic> plansList = plansData["plans"];
            return plansList.cast<Map<String, dynamic>>();
          } else {
            throw Exception("Invalid data format: Expected 'plans' array");
          }
        } else {
          throw Exception("Invalid data format: Expected 'plans' key");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<String> buyData(BuildContext context, String mobileNetwork, String dataPlan, String mobileNumber) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Authorization");
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/data-bundle/buy-data"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }, body: json.encode({
        "mobileNetwork": mobileNetwork,
        "dataPlan": dataPlan,
        "mobileNumber": mobileNumber,
      }));
      print(response.body);
      final responseData = jsonDecode(response.body);
      return responseData['status'];
    } catch (e) {
      return "SERVER_ERROR";
    }
  }

  Future<void> saveDataBundle({
    required BuildContext context,
    required String bundle,
    required String duration,
    required String value,
    required String service,
    required String provider,
    required String benefit,
    required String period,
    required String price,
  }) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/api/v1/boks/data-bundle/save-bundle"), headers: {
        "Content-Type": "application/json"
      }, body: json.encode({
        "bundle": bundle,
        "duration": duration,
        "value": value,
        "service": service,
        "provider": provider,
        "benefit": benefit,
        "period": period,
        "price": price,
      }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      } else {
        final responseData = jsonDecode(response.body);
        showSnackBar(context: context, message: responseData['message'], title: responseData['title']);
      }
    } catch (e) {
      showSnackBar(context: context, message: "Server Error", title: "Server Error");
    }
  }

}