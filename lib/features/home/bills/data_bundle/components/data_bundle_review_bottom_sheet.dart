import 'package:boks/features/home/components/balance_card.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/show_snack_bar.dart';
import 'package:boks/utility/shared_components/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/constants/app_strings.dart';
import '../service/data_bundle_service.dart';

class DataBundleReviewBottomSheet extends StatefulWidget {
  final Map<String, dynamic> data;
  final String serviceProvider;
  final String phoneNumber;

  const DataBundleReviewBottomSheet({
    super.key,
    required this.data,
    required this.serviceProvider,
    required this.phoneNumber,
  });

  @override
  State<DataBundleReviewBottomSheet> createState() =>
      _DataBundleReviewBottomSheetState();
}

class _DataBundleReviewBottomSheetState
    extends State<DataBundleReviewBottomSheet> {
  bool isLoading = false;
  final DataBundleService _dataBundleService = DataBundleService();

  Future<void> _buyDataBundle({
    required BuildContext context,
    required String mobileNetwork,
    required String dataPlan,
    required String mobileNumber,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      String response = await _dataBundleService.buyData(
        context,
        mobileNetwork,
        dataPlan,
        mobileNumber,
      );
      if (response == "INVALID_MOBILE_NUMBER") {
        setState(() {
          isLoading = false;
          showSnackBar(
            context: context,
            message:
                "The phone number you provided is invalid, please check the number and try again",
            title: "Invalid Phone Number",
          );
        });
      } else if (response == "ORDER_COMPLETED" ||
          response == "ORDER_RECEIVED") {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => SuccessScreen(
                    title: "Success!",
                    subMessage:
                        "Your purchase of ${extractDataSize(widget.data['PRODUCT_NAME'])} for ${widget.phoneNumber} has been successfully completed. Thank you for your transaction.",
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
            ),
          );
        });
      } else {
        setState(() {
          isLoading = false;
          showSnackBar(
            context: context,
            message:
                "Purchase failed, for some unknown reason, please try again later. Thank You.",
            title: "Purchase Failed",
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        showSnackBar(
          context: context,
          message:
              "We encountered an error trying to process your request, please try again later. Thank You.",
          title: "Something Went Wrong",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                        child: Text("Close", style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Data Bundle",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${extractDataSize(widget.data['PRODUCT_NAME'])}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding:
                                          offers(
                                                widget.data['PRODUCT_NAME'],
                                              ).isEmpty
                                              ? EdgeInsets.zero
                                              : const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 2,
                                              ),
                                      child: Text(
                                        offers(widget.data['PRODUCT_NAME']).trim(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Purchase Details",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: AppStrings.nairaSign,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${_formatPrice(double.parse(widget.data['PRODUCT_AMOUNT']))}",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Service Provider",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            widget.serviceProvider ==
                                                                    "01"
                                                                ? "MTN"
                                                                : widget.serviceProvider ==
                                                                    "02"
                                                                ? "GLO"
                                                                : widget.serviceProvider ==
                                                                    "03"
                                                                ? "9Mobile"
                                                                : "Airtel",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Phone Number",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: widget.phoneNumber,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Data Plan",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RichText(
                                                    textAlign: TextAlign.end,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: extractDays(
                                                            widget
                                                                .data['PRODUCT_NAME'],
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "Payment Method",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                BalanceCard(),
                                const SizedBox(height: 50),
                                CustomButton(
                                  title: "Pay",
                                  onClick:
                                      () => _buyDataBundle(
                                        context: context,
                                        mobileNetwork: widget.serviceProvider,
                                        dataPlan: widget.data['PRODUCT_ID'],
                                        mobileNumber: widget.phoneNumber,
                                      ),
                                  isLoading: isLoading ? true : false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
        ],
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
