import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/selected_tv_and_cable_service_provider.dart';
import '../provider/tv_and_cable_service_provider.dart';

class TvAndCableCardStyle extends StatelessWidget {
  final Map<String, dynamic> data;
  const TvAndCableCardStyle({super.key, required this.data});

  // Map service provider names to their respective image paths
  static const Map<String, String> _providerImages = {
    'dstv': "images/d496ff9ef976b4a10f4719dfcd0ece6b.jpg",
    'gotv': "images/b038f6d349e7922321216079117fd7da.jpg",
    'startimes': "images/a66f7421c6e04c3361923f6e9162077f.jpg",
    'showmax': "images/Showmax-Logo.png",
  };
  static const Map<String, String> _providerNames = {
    'dstv': "DSTv",
    'gotv': "GOTv",
    'startimes': "StarTimes",
    'showmax': "ShowMax",
  };
  static const String _defaultImage = "images/Showmax-Logo.png";
  static const String _defaultName = "Service Provider";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          final providerName = data['ID'] ?? '';
          final imageUrl = _getImagePathForProvider(providerName);
          final providerNames = _getNamePathForProvider(providerName);
          final provider = TvAndCableServiceProvider(
            id: data['ID'] ?? '',
            name: providerNames,
            imageUrl: imageUrl,
          );
          Provider.of<SelectedTvAndCableServiceProvider>(context, listen: false).selectProvider(provider);
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
    final providerName = data['ID'] ?? ''; // Use 'ID' instead of 'NAME'
    final imagePath = _getImagePathForProvider(providerName);

    return Container(
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: Image.asset(imagePath, fit: BoxFit.contain,),
    );
  }

  String _getImagePathForProvider(String providerName) {
    final lowerCaseProviderName = providerName.toLowerCase();
    return _providerImages[lowerCaseProviderName] ?? _defaultImage;
  }

  String _getNamePathForProvider(String providerName) {
    final lowerCaseProviderName = providerName.toLowerCase();
    return _providerNames[lowerCaseProviderName] ?? _defaultName;
  }

  Widget _buildProviderName() {
    final providerName = data['ID'] ?? '';
    final namePath = _getNamePathForProvider(providerName);
    return Text(
      namePath,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}