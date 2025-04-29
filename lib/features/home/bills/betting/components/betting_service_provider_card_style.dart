import 'package:boks/features/home/bills/betting/provider/betting_service_provider.dart';
import 'package:boks/features/home/bills/betting/provider/selected_betting_service_provider.dart';
import 'package:boks/features/home/bills/electricity/provider/selected_electricity_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BettingServiceProviderCardStyle extends StatelessWidget {
  final Map<String, dynamic> data;
  const BettingServiceProviderCardStyle({super.key, required this.data});

  static const Map<String, String> _providerImages = {
    'msport': "images/images (3).jpeg",
    'naijabet': "images/images (5).jpeg",
    'nairabet': "images/images (6).jpeg",
    'bet9ja-agent': "images/4bcd0c855ed27333be9b7f559a900552.jpg",
    'betland': "images/images (4).png",
    'betlion': "images/bet_lion_logo.png",
    'supabet': "images/images (5).png",
    'bet9ja': "images/4bcd0c855ed27333be9b7f559a900552.jpg",
    'bangbet': "images/images (1).jpeg",
    'betking': "images/images.png",
    '1xbet': "images/c306a16f287e10971b0d166290bffb04.jpg",
    'betway': "images/betway_logo.png",
    'merrybet': "images/images (7).jpeg",
    'mlotto': "images/images (8).jpeg",
    'western-lotto': "images/images (9).jpeg",
    'hallabet': "images/images (6).png",
    'green-lotto': "images/images (10).jpeg",
  };
  static const Map<String, String> _providerNames = {
    'msport': "MSport",
    'naijabet': "Naija Bet",
    'nairabet': "NairaBet",
    'bet9ja-agent': "Bet9ja Agent",
    'betland': "Bet Land",
    'betlion': "Bet Lion",
    'supabet': "SupaBet",
    'bet9ja': "Bet9Ja",
    'bangbet': "BangBet",
    'betking': "BetKing",
    '1xbet': "1xBet",
    'betway': "BetWay",
    'merrybet': "MerryBet",
    'mlotto': "MLotto",
    'western-lotto': "Western Lotto",
    'hallabet': "HallaBet",
    'green-lotto': "Green Lotto",
  };
  static const String _defaultImage = "images/images (8).png";
  static const String _defaultName = "Service Provider";

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          final providerName = data['PRODUCT_CODE'] ?? '';
          final imageUrl = _getImagePathForProvider(providerName);
          final providerNames = _getNamePathForProvider(providerName);
          final provider = BettingServiceProvider(
            id: data['PRODUCT_CODE'] ?? '',
            name: providerNames,
            imageUrl: imageUrl,
          );
          Provider.of<SelectedBettingServiceProvider>(context, listen: false).selectProvider(provider);
          Navigator.pop(context);
        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.0),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              _buildProviderLogo(),
              const SizedBox(width: 5),
              _buildProviderName(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the provider logo
  Widget _buildProviderLogo() {
    final providerName = data['PRODUCT_CODE'] ?? '';
    final imagePath = _getImagePathForProvider(providerName);

    return Container(
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: Image.asset(imagePath,),
    );
  }
  String _getImagePathForProvider(String providerName) {
    for (final key in _providerImages.keys) {
      if (providerName.contains(key)) {
        return _providerImages[key]!;
      }
    }
    return _defaultImage;
  }
  String _getNamePathForProvider(String providerName) {
    final lowerCaseProviderName = providerName.toLowerCase();
    return _providerNames[lowerCaseProviderName] ?? _defaultName;
  }

  Widget _buildProviderName() {
    final providerName = data['PRODUCT_CODE'] ?? '';
    final namePath = _getNamePathForProvider(providerName);
    return Text(
      namePath,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}