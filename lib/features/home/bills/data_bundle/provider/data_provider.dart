import 'package:boks/utility/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'data_model_provider.dart';

class DataProvider with ChangeNotifier {
  DataModelProvider? _selectedProvider;

  // Define a default provider
  final DataModelProvider defaultProvider = DataModelProvider(
    id: '01',
    imageUrl: "logo-mtn-ivory-coast-brand-product-design-mtn-group-teamwork-interpersonal-skills-a97c54a1765e8cf646301d936fa6a3ce.png",
  );

  DataProvider() {
    // Initialize with the default provider
    _selectedProvider = defaultProvider;
  }

  DataModelProvider? get selectedProvider => _selectedProvider;

  void selectProvider(DataModelProvider provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void clearSelection() {
    // Reset to the default provider
    _selectedProvider = defaultProvider;
    notifyListeners();
  }
}