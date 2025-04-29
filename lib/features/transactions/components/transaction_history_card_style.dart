import 'package:boks/features/transactions/screens/transaction_receipt_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utility/constants/app_colors.dart';
import '../../../utility/constants/app_strings.dart';

class TransactionHistoryCardStyle extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionHistoryCardStyle({super.key, required this.transaction});

  @override
  State<TransactionHistoryCardStyle> createState() =>
      _TransactionHistoryCardStyleState();
}

class _TransactionHistoryCardStyleState
    extends State<TransactionHistoryCardStyle> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => TransactionReceiptViewScreen(
                    transaction: widget.transaction,
                  ),
            ),
          );
        },
        child:
            widget.transaction['isTransfer'] == false &&
                    widget.transaction['isDeposit'] == false
                ? Container(
                  // height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(AppColors.primaryColor).withOpacity(0.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 1,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: widget.transaction['transactionReference'],
                          child: Container(
                            height: 35,
                            width: 35,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: _getNetworkLogo(
                                  widget.transaction['recipient'],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.transaction['title'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${formatTransactionDate(widget.transaction['createdAt'] ?? 'N/A')}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppStrings.nairaSign,
                                    style: TextStyle(
                                      color: Color(AppColors.primaryColor),
                                      fontSize: 10,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${widget.transaction['amount'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Color(AppColors.primaryColor),
                                      fontSize: 12,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${widget.transaction['status'] ?? 'N/A'}",
                              style: TextStyle(
                                color:
                                    widget.transaction['status'] == "success"
                                        ? Colors.green
                                        : widget.transaction['status'] ==
                                            "pending"
                                        ? Colors.orange
                                        : Colors.red,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : Container(
                  // height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(AppColors.primaryColor).withOpacity(0.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 1,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: widget.transaction['transactionReference'],
                          child: Container(
                            height: 35,
                            width: 35,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green.withOpacity(0.3),
                                    ),
                                    child:
                                        widget
                                                .transaction['recipientDetails']['image']
                                                .isEmpty
                                            ? Icon(
                                              Icons.arrow_downward_rounded,
                                              size: 15,
                                              color: Colors.green,
                                            )
                                            : Container(
                                              height: 50,
                                              width: 50,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                shape: BoxShape.circle,
                                              ),
                                              child:
                                                  widget.transaction['recipientDetails']['image'] !=
                                                          null
                                                      ? Image.network(
                                                        widget
                                                            .transaction['recipientDetails']['image'],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          err,
                                                          st,
                                                        ) {
                                                          return Center(
                                                            child: Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.grey,
                                                              size: 14,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                      : Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.grey,
                                                          size: 14,
                                                        ),
                                                      ),
                                            ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.7),
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          widget.transaction['credit']
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          size: 8,
                                          color: widget.transaction['credit'] ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.transaction['title'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${formatTransactionDate(widget.transaction['createdAt'] ?? 'N/A')}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        widget.transaction['credit']
                                            ? "+"
                                            : "-",
                                    style: TextStyle(
                                      color: Color(AppColors.primaryColor),
                                      fontSize: 10,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppStrings.nairaSign,
                                    style: TextStyle(
                                      color: Color(AppColors.primaryColor),
                                      fontSize: 10,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${widget.transaction['amount'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Color(AppColors.primaryColor),
                                      fontSize: 12,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${widget.transaction['status'] ?? 'N/A'}",
                              style: TextStyle(
                                color:
                                    widget.transaction['status'] == "success"
                                        ? Colors.green
                                        : widget.transaction['status'] ==
                                            "pending"
                                        ? Colors.orange
                                        : Colors.red,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  String formatTransactionDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('EEE, d MMM y');
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
}
