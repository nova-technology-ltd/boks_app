import 'package:boks/features/home/bills/data_bundle/components/data_bundle_review_bottom_sheet.dart';
import 'package:boks/utility/shared_components/enter_pin_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/constants/app_strings.dart';
import '../service/data_bundle_service.dart';

class DataPlanCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String serviceProvider;
  final String phoneNumber;
  const DataPlanCard({super.key, required this.data, required this.serviceProvider, required this.phoneNumber});

  @override
  State<DataPlanCard> createState() => _DataPlanCardState();
}

class _DataPlanCardState extends State<DataPlanCard> {
  Future<void> _showDataBundleReviewBottomSheet(BuildContext context,
  final Map<String, dynamic> data, String serviceProvider, String phoneNumber) async {
    showCupertinoModalPopup(context: context, builder: (context) {
      return DataBundleReviewBottomSheet(data: data, serviceProvider: serviceProvider, phoneNumber: phoneNumber,);
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDataBundleReviewBottomSheet(context, widget.data, widget.serviceProvider, widget.phoneNumber),
      child: SizedBox(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    // height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${extractDataSize(widget.data['PRODUCT_NAME'])}/",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: extractDays(widget.data['PRODUCT_NAME']),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.nairaSign,
                                  style: TextStyle(
                                    color: Color(AppColors.primaryColor),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "${_formatPrice(double.parse(widget.data['PRODUCT_AMOUNT']))}",
                                  style: TextStyle(
                                    color: Color(AppColors.primaryColor),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: offers(widget.data['PRODUCT_NAME']).isEmpty ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                      child: Text(
                        offers(widget.data['PRODUCT_NAME']).trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.orange,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              // height: 5,
              // width: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: checkForSME(widget.data['PRODUCT_NAME']).isEmpty ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                child: Text(
                  checkForSME(widget.data['PRODUCT_NAME']),
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  String extractDataSize(String productName) {
    RegExp regex = RegExp(r'(\d+(\.\d+)?\s?(GB|MB))');
    Match? match = regex.firstMatch(productName);
    return match != null ? match.group(0)! : productName;
  }

  String extractDays(String productName) {
    RegExp regex = RegExp(r'(\d+\sday(s)?)');
    Match? match = regex.firstMatch(productName);
    return match != null ? match.group(0)! : productName;
  }

  String offers(String productName) {
    RegExp regex = RegExp(r'\+\s?([^-\n]+)');
    Match? match = regex.firstMatch(productName);
    return match != null ? match.group(0)! : "";
  }

  String checkForSME(String productName) {
    RegExp regex = RegExp(r'SME', caseSensitive: false);
    return regex.hasMatch(productName) ? "SME" : "";
  }
}
