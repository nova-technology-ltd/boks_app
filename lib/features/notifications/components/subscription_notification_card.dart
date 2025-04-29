import 'package:boks/utility/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utility/shared_components/phone_number_utility.dart';

class SubscriptionNotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;
  const SubscriptionNotificationCard({super.key, required this.notification});

  @override
  State<SubscriptionNotificationCard> createState() => _SubscriptionNotificationCardState();
}

class _SubscriptionNotificationCardState extends State<SubscriptionNotificationCard> {
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

    String phoneNumber = PhoneNumberUtils.extractPhoneNumber(widget.notification['message']);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.transparent
              ),
              child: Stack(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Container(
                          height: 43,
                          width: 43,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: _getNetworkLogo(
                            phoneNumber,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.notification['title'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          "${formatTransactionDate(widget.notification['createdAt'])}",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Text(
                      addCurrencyPrefix(widget.notification['message']),
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
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
      return dateString;
    }
  }

  String addCurrencyPrefix(String message) {
    List<String> parts = message.split(' ');
    int ofIndex = parts.indexOf("of");
    int forIndex = parts.indexOf("for");

    if (ofIndex != -1 && forIndex != -1 && ofIndex + 1 < forIndex) {
      String amount = parts[ofIndex + 1];
      parts[ofIndex + 1] = "${AppStrings.nairaSign}$amount";
      return parts.join(' ');
    }
    return message;
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

  String extractPhoneNumber(String text) {
    // Regular expression to match Nigerian phone numbers in various formats
    final phoneRegex = RegExp(
        r'(?:\+|0|234)?(?:\(0\))?(?:80|81|70|90|91|30|50|60|20|10|21|40)(?:\d{8}|\d{9})'
    );

    // Find the first match in the text
    final match = phoneRegex.firstMatch(text);

    if (match == null) return ''; // Return empty if no match found

    String matchedNumber = match.group(0)!;

    // Normalize the number to 10 digits (without country code)
    if (matchedNumber.startsWith('+234') || matchedNumber.startsWith('234')) {
      return matchedNumber.substring(matchedNumber.length - 10);
    } else if (matchedNumber.startsWith('0')) {
      return matchedNumber.substring(1);
    } else if (matchedNumber.length == 10) {
      return matchedNumber;
    } else {
      // For other cases, return the last 10 digits
      return matchedNumber.length > 10
          ? matchedNumber.substring(matchedNumber.length - 10)
          : matchedNumber;
    }
  }
}
