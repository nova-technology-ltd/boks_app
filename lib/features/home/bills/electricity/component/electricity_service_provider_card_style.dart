import 'package:boks/features/home/bills/electricity/provider/selected_electricity_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/electricity_sevice_provider.dart';

class ElectricityServiceProviderCardStyle extends StatelessWidget {
  final Map<String, dynamic> data;
  const ElectricityServiceProviderCardStyle({super.key, required this.data});

  // Map service provider names to their respective image paths
  static const Map<String, String> _providerImages = {
    'EEDC': "images/images (7).png",
    'EKEDC': "images/images (11).jpeg",
    'Abuja': "images/images (12).jpeg",
    'Kaduna': "images/images (13).jpeg",
    'BEDC': "images/images (16).jpeg",
    'YEDC': "images/images (17).jpeg",
    'Kano Electric': "images/images (9).png",
    'PHEDC': "images/PHED.png",
    'JEDC': "images/images (14).jpeg",
    'APLE': "images/APLE-Logo-300x300.png",
  };
  static const String _defaultImage = "images/images (8).png";

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          final providerName = data['NAME'] ?? '';
          final imageUrl = _getImagePathForProvider(providerName);
          final provider = ElectricityServiceProvider(
            id: data['ID'] ?? '',
            name: data['NAME'] ?? '',
            imageUrl: imageUrl,
          );
          Provider.of<SelectedElectricityServiceProvider>(context, listen: false).selectProvider(provider);
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
    final providerName = data['NAME'] ?? '';
    final imagePath = _getImagePathForProvider(providerName);

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Image.asset(imagePath),
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
  Widget _buildProviderName() {
    return Text(
      data['NAME'] ?? '',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}