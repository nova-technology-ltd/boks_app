import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'betting_service_provider.dart';

class SelectedBettingServiceProvider with ChangeNotifier {
  BettingServiceProvider? _selectedProvider;

  // Define a default provider
  final BettingServiceProvider defaultProvider = BettingServiceProvider(
    id: '00',
    name: 'Select Provider',
    imageUrl: "",
  );

  SelectedBettingServiceProvider() {
    // Initialize with the default provider
    _selectedProvider = defaultProvider;
  }

  BettingServiceProvider? get selectedProvider => _selectedProvider;

  void selectProvider(BettingServiceProvider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void clearSelection() {
    // Reset to the default provider
    _selectedProvider = defaultProvider;
    notifyListeners();
  }
}