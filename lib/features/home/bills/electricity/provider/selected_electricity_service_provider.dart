import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'electricity_sevice_provider.dart';

class SelectedElectricityServiceProvider with ChangeNotifier {
  ElectricityServiceProvider? _selectedProvider;

  // Define a default provider
  final ElectricityServiceProvider defaultProvider = ElectricityServiceProvider(
    id: '00',
    name: 'Select Provider',
    imageUrl: "",
  );

  SelectedElectricityServiceProvider() {
    // Initialize with the default provider
    _selectedProvider = defaultProvider;
  }

  ElectricityServiceProvider? get selectedProvider => _selectedProvider;

  void selectProvider(ElectricityServiceProvider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void clearSelection() {
    // Reset to the default provider
    _selectedProvider = defaultProvider;
    notifyListeners();
  }
}