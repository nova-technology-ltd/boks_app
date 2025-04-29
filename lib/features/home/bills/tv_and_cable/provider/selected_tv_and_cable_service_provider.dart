import 'package:flutter/material.dart';
import 'tv_and_cable_service_provider.dart';

class SelectedTvAndCableServiceProvider with ChangeNotifier {
  TvAndCableServiceProvider? _selectedProvider;

  // Define a default provider
  final TvAndCableServiceProvider defaultProvider = TvAndCableServiceProvider(
    id: 'dstv',
    name: 'DSTv',
    imageUrl: "images/d496ff9ef976b4a10f4719dfcd0ece6b.jpg",
  );

  SelectedTvAndCableServiceProvider() {
    _selectedProvider = defaultProvider;
  }

  TvAndCableServiceProvider? get selectedProvider => _selectedProvider;

  void selectProvider(TvAndCableServiceProvider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void clearSelection() {
    // Reset to the default provider
    _selectedProvider = defaultProvider;
    notifyListeners();
  }
}