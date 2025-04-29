import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'airtime_model_provider.dart';

class AirtimeProvider with ChangeNotifier {
  AirtimeModelProvider? _selectedProvider;
  final AirtimeModelProvider defaultProvider = AirtimeModelProvider(
    id: '00',
    imageUrl: "",
    name: "",
  );

  AirtimeProvider() {
    // Initialize with the default provider
    _selectedProvider = defaultProvider;
  }

  AirtimeModelProvider? get selectedProvider => _selectedProvider;

  void selectProvider(AirtimeModelProvider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void clearSelection() {
    // Reset to the default provider
    _selectedProvider = defaultProvider;
    notifyListeners();
  }
}