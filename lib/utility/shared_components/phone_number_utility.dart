import 'package:flutter/material.dart';

class PhoneNumberUtils {
  // Extract and normalize phone number
  static String extractPhoneNumber(String text) {
    final phoneRegex = RegExp(
        r'(?:\+|0|234)?(?:\(0\))?(?:80|81|70|90|91|30|50|60|20|10|21|40)(?:\d{8}|\d{9})'
    );

    final match = phoneRegex.firstMatch(text);
    if (match == null) return '';

    String matchedNumber = match.group(0)!;

    if (matchedNumber.startsWith('+234') || matchedNumber.startsWith('234')) {
      return matchedNumber.substring(matchedNumber.length - 10);
    } else if (matchedNumber.startsWith('0')) {
      return matchedNumber.substring(0);
    } else if (matchedNumber.length == 10) {
      return matchedNumber;
    } else {
      return matchedNumber.length > 10
          ? matchedNumber.substring(matchedNumber.length - 10)
          : matchedNumber;
    }
  }

  // Identify network provider
  static String getNetworkProvider(String phoneNumber) {
    if (phoneNumber.isEmpty) return 'Unknown';

    // Get the first 3 digits (network prefix)
    String prefix = phoneNumber.length >= 3 ? phoneNumber.substring(0, 3) : '';

    // Nigerian network prefixes
    const mtnPrefixes = ['803', '806', '703', '706', '813', '814', '810', '816', '903', '906'];
    const airtelPrefixes = ['802', '808', '708', '701', '902', '904', '907', '901'];
    const gloPrefixes = ['805', '807', '705', '815', '811', '905'];
    const nineMobilePrefixes = ['809', '818', '817', '909', '908'];

    if (mtnPrefixes.contains(prefix)) return 'MTN';
    if (airtelPrefixes.contains(prefix)) return 'Airtel';
    if (gloPrefixes.contains(prefix)) return 'GLO';
    if (nineMobilePrefixes.contains(prefix)) return '9Mobile';

    return 'Unknown';
  }

  // Get network logo widget
  static Widget getNetworkLogo(String phoneNumber) {
    String provider = getNetworkProvider(phoneNumber);
    String logoAssetPath = _getLogoAssetPath(provider);

    if (logoAssetPath.isNotEmpty) {
      return Image.asset(
        "images/$logoAssetPath",
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    } else {
      return Transform.rotate(
        angle: 3.9,
        child: const Icon(
          Icons.sim_card,
          color: Colors.green,
          size: 20,
        ),
      );
    }
  }

  // Helper function to map provider to logo
  static String _getLogoAssetPath(String provider) {
    final Map<String, String> providerLogos = {
      'MTN': 'logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png',
      'GLO': '622ec535be0300f53a53b2e7b54c1646.jpg',
      'Airtel': '0b2780b8ad9be7d07fcd436802c82da6.jpg',
      '9Mobile': 'd1fdd6b0530cedafa8a8a8bb0133d9ff.jpg',
    };
    return providerLogos[provider] ?? '';
  }
}
