import 'dart:io';

import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import '../../../utility/constants/app_colors.dart';
import '../../../utility/constants/app_strings.dart';
import '../../../utility/shared_components/custom_back_button.dart';

class TransactionReceiptViewScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  const TransactionReceiptViewScreen({super.key, required this.transaction});

  @override
  State<TransactionReceiptViewScreen> createState() => _TransactionReceiptViewScreenState();
}

class _TransactionReceiptViewScreenState extends State<TransactionReceiptViewScreen> {
  String getNetworkProvider(String phoneNumber) {
    if (phoneNumber.startsWith('+234')) {
      phoneNumber = '0' + phoneNumber.substring(4);
    }
    String prefix = phoneNumber.substring(0, 4);
    Map<String, String> networkPrefixes = {
      'MTN': '0703,0706,0803,0806,0810,0813,0814,0816,0903,0906,0913,0916',
      'GLO': '0705,0805,0807,0811,0815,0905,0915',
      'Airtel': '0701,0708,0802,0808,0812,0901,0902,0904,0907,0912',
      '9Mobile': '0809,0817,0818,0909,0908',
    };
    for (var entry in networkPrefixes.entries) {
      if (entry.value.split(',').contains(prefix)) {
        return entry.key;
      }
    }

    return 'Unknown Network';
  }

  final List<String> services = ["01", "02", "03", "04"];

  final List<String> titles = ["MTN", "GLO", "9Mobile", "Airtel"];

  final List<String> logos = [
    "logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png",
    "622ec535be0300f53a53b2e7b54c1646.jpg",
    "0b2780b8ad9be7d07fcd436802c82da6.jpg",
    "d1fdd6b0530cedafa8a8a8bb0133d9ff.jpg",
  ];

  final ScreenshotController screenshotController = ScreenshotController();

  // Add this method to handle sharing
  Future<void> _shareReceipt() async {
    try {
      // Capture the widget as an image
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes == null) {
        throw Exception("Failed to capture screenshot");
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/receipt.png').create();
      await imagePath.writeAsBytes(imageBytes);

      // Share the image
      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Transaction Receipt',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing receipt: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(AppColors.primaryColor),
              surfaceTintColor: Color(AppColors.primaryColor),
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Receipt",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              bottom: PreferredSize(preferredSize: Size(MediaQuery.of(context).size.width, 100), child: Container(
                decoration: BoxDecoration(
                  color: Color(AppColors.primaryColor),
                ),
              )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              leading: CustomBackButton(context: context),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 0)
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                color: widget.transaction['status'] == "success"
                                                    ? Colors.green.withOpacity(0.3)
                                                    : widget.transaction['status'] == "pending"
                                                    ? Colors.orange
                                                    : Colors.red,
                                                shape: BoxShape.circle
                                            ),
                                            child: Center(
                                              child: Icon(
                                                widget.transaction['status'] == "success"
                                                    ? Icons.check
                                                    : widget.transaction['status'] == "pending"
                                                    ? Icons.cancel
                                                    : Icons.downloading,
                                                color: widget.transaction['status'] == "success"
                                                    ? Colors.green
                                                    : widget.transaction['status'] == "pending"
                                                    ? Colors.orange
                                                    : Colors.red,
                                                size: 11,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 2,),
                                          Text(
                                            "${widget.transaction['status'] ?? 'N/A'}",
                                            style: TextStyle(
                                              color:
                                              widget.transaction['status'] == "success"
                                                  ? Colors.green
                                                  : widget.transaction['status'] == "pending"
                                                  ? Colors.orange
                                                  : Colors.red,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: widget.transaction['transactionReference'],
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: widget.transaction['isTransfer'] == false && widget.transaction['isDeposit'] == false  ? Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle
                                              ),
                                              child: _getNetworkLogo(
                                                widget.transaction['recipient'],
                                              ),
                                            ) : Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green.withOpacity(0.3)
                                                ),
                                                child: widget.transaction['recipientDetails']['image'].isEmpty ? Icon(Icons.arrow_downward_rounded, size: 15, color: Colors.green,) : Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: widget.transaction['recipientDetails']['image'] != null
                                                      ? CircleAvatar(
                                                    backgroundImage: NetworkImage(widget.transaction['recipientDetails']['image']),
                                                  )
                                                      : Icon(Icons.person, color: Colors.grey[600]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        widget.transaction['isTransfer'] == false && widget.transaction['isDeposit'] == false ? getNetworkProvider(widget.transaction['recipient']) : widget.transaction['title'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            widget.transaction['isTransfer'] == false && widget.transaction['isDeposit'] == false ? const SizedBox(height: 15,) : const SizedBox.shrink(),
                            widget.transaction['isTransfer'] == false && widget.transaction['isDeposit'] == false ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Text(
                                  widget.transaction["recipient"] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ) : const SizedBox.shrink(),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: AppStrings.nairaSign,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.transaction['amount'] ?? 'N/A'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            widget.transaction['isTransfer'] ? const SizedBox(height: 10,) : const SizedBox.shrink(),
                            widget.transaction['isTransfer'] ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recipient",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      "${widget.transaction['recipientDetails']['firstName'].trim()} ${widget.transaction['recipientDetails']['lastName'].trim()} ${widget.transaction['recipientDetails']['otherNames'].trim()}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ) : const SizedBox.shrink(),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.transaction["description"].isEmpty ? "none" : widget.transaction["description"],
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 0)
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transaction Details",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaction Reference",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.transaction["transactionReference"] ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.transaction["category"] ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Balance Before",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            textAlign: TextAlign.end,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: AppStrings.nairaSign,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    // fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${_formatPrice(double.parse(widget.transaction['balanceBefore'].toString()))}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black
                                                    // fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Balance After",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            textAlign: TextAlign.end,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: AppStrings.nairaSign,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    // fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${_formatPrice(double.parse(widget.transaction['balanceAfter'].toString()))}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black
                                                    // fontWeight: FontWeight.w500,
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
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: widget.transaction["status"] == "success" ? Colors.green.withOpacity(0.2) : widget.transaction["status"] == "pending" ? Colors.orange.withOpacity(0.2): Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                    child: Center(
                                      child: Text(
                                        widget.transaction["status"] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.transaction["status"] == "success" ? Colors.green : widget.transaction["status"] == "pending" ? Colors.orange : Colors.red
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fee",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppStrings.nairaSign,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${widget.transaction['fee'] ?? 'N/A'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Method",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Text(
                                  widget.transaction["paymentMethod"] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Currency",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.transaction["currency"] ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            widget.transaction['isTransfer'] == false && widget.transaction['isDeposit'] == false ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaction Type",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                ),
                                Text(
                                  widget.transaction["title"] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ) : const SizedBox.shrink(),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaction Date",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey
                                  ),
                                ),
                                Text(
                                  "${formatTransactionDate(widget.transaction['createdAt'] ?? 'N/A')}",
                                  style: TextStyle(
                                    fontSize: 12,
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
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomButton(title: "Share", onClick: _shareReceipt, isLoading: false),

            ),
          ),
        ],
      ),
    );
  }

  String formatTransactionDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('EEE, d MMM y, h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Add these methods to your class
  Widget _getNetworkLogo(String phoneNumber) {
    String provider = getNetworkProvider(phoneNumber);
    String logoAssetPath = _getLogoAssetPath(provider);

    if (logoAssetPath.isNotEmpty) {
      return Image.asset("images/$logoAssetPath", fit: BoxFit.cover);
    } else {
      // Fallback widget if no logo is found
      return Transform.rotate(
        angle: 3.9,
        child: Image.asset(
          "images/arrow-up-left-from-circle.png",
          color: Colors.green,
        ),
      );
    }
  }

  String _getLogoAssetPath(String provider) {
    // Map network providers to their logo filenames
    final Map<String, String> providerLogos = {
      'MTN':
      'logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png',
      'GLO': '622ec535be0300f53a53b2e7b54c1646.jpg',
      'Airtel': 'd1fdd6b0530cedafa8a8a8bb0133d9ff.jpg',
      '9Mobile': '0b2780b8ad9be7d07fcd436802c82da6.jpg',
    };

    return providerLogos[provider] ?? '';
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

}
