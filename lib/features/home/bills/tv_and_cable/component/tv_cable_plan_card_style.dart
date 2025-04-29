import 'package:boks/utility/shared_components/enter_pin_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/constants/app_colors.dart';
import '../../../../../utility/constants/app_strings.dart';
import '../provider/selected_tv_and_cable_service_provider.dart';
import '../service/tv_and_cable_service.dart';

class TvCablePlanCardStyle extends StatefulWidget {
  final Map<String, dynamic> data;
  final String smartCardNumber;
  final String phoneNumber;

  const TvCablePlanCardStyle({
    super.key,
    required this.data,
    required this.smartCardNumber,
    required this.phoneNumber,
  });

  @override
  State<TvCablePlanCardStyle> createState() => _TvCablePlanCardStyleState();
}

class _TvCablePlanCardStyleState extends State<TvCablePlanCardStyle> {
  final TvAndCableService _tvAndCableService = TvAndCableService();

  Future<void> _showAccountPINBottomSheet(BuildContext context) async {
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (context) {
    //     return EnterPinBottomSheet();
    //   },
    // );
  }

  Future<void> _subscribeShow(
    BuildContext context,
    String cableTV,
    String packageCode,
    String smartCardNo,
    String phoneNo,
  ) async {
    try {
      await _tvAndCableService.subScribeCableTv(
        context: context,
        cableTV: cableTV,
        packageCode: packageCode,
        smartCardNo: smartCardNo,
        phoneNo: phoneNo,
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<SelectedTvAndCableServiceProvider>(
          context,
        ).selectedProvider;
    return GestureDetector(
      onTap:
          () => _subscribeShow(
            context,
            selectedItems!.id,
            widget.data['PACKAGE_ID'],
            widget.smartCardNumber,
            widget.phoneNumber,
          ),
      child: SizedBox(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    // width: 150,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(),
                          child: Image.asset(
                            widget.data['PACKAGE_NAME'].toLowerCase().contains(
                                  "padi",
                                )
                                ? "images/dstv_padi_img.jpg"
                                : widget.data['PACKAGE_NAME']
                                    .toLowerCase()
                                    .contains("yanga")
                                ? "images/dstv_yanga_img.webp"
                                : widget.data['PACKAGE_NAME']
                                    .toLowerCase()
                                    .contains("compact")
                                ? "images/dstv_compact_img.webp"
                                : widget.data['PACKAGE_NAME']
                                    .toLowerCase()
                                    .contains("compact plus")
                                ? "images/dstv_compact_plus_img.webp"
                                : widget.data['PACKAGE_NAME']
                                    .toLowerCase()
                                    .contains("confam")
                                ? "images/dstv_confam_img.jpg"
                                : "images/dstv_premium_img.webp",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.data['PACKAGE_NAME'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding:
                          offers(widget.data['PACKAGE_NAME']).isEmpty
                              ? EdgeInsets.zero
                              : const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 2,
                              ),
                      child: Text(
                        offers(widget.data['PACKAGE_NAME']).trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                      checkForSME(widget.data['PACKAGE_NAME']).isEmpty
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 2,
                          ),
                  child: Text(
                    checkForSME(widget.data['PACKAGE_NAME']),
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ),
              ),
            ),
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

  String extractDataSize(String packageName) {
    RegExp regex = RegExp(r'(\d+(\.\d+)?\s?(GB|MB))');
    Match? match = regex.firstMatch(packageName);
    return match != null ? match.group(0)! : packageName;
  }

  String extractDays(String packageName) {
    RegExp regex = RegExp(r'(\d+\sday(s)?)');
    Match? match = regex.firstMatch(packageName);
    return match != null ? match.group(0)! : packageName;
  }

  String offers(String packageName) {
    RegExp regex = RegExp(r'\+\s?([^-\n]+)');
    Match? match = regex.firstMatch(packageName);
    return match != null ? match.group(0)! : "";
  }

  String checkForSME(String packageName) {
    RegExp regex = RegExp(
      r'SME',
      caseSensitive: false,
    ); // Case-insensitive match
    return regex.hasMatch(packageName) ? "SME" : "";
  }
}
