import 'package:boks/utility/shared_components/custom_loader.dart';
import 'package:flutter/material.dart';

class WaecServiceBottomSheet extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> data;
  final Function(String) onItemSelected;
  final Function(String) price;
  final Function(String) productCode;
  final TextEditingController controller;

  const WaecServiceBottomSheet({
    super.key,
    required this.data,
    required this.onItemSelected,
    required this.controller, required this.price, required this.productCode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoader());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final items = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Container(
                // height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var item in items)
                            ListTile(
                              title: Text(item['PRODUCT_DESCRIPTION'] ?? ''),
                              onTap: () {
                                final selectedService = item['PRODUCT_DESCRIPTION'];
                                final finalPrice = item['PRODUCT_AMOUNT'];
                                final examCode = item['PRODUCT_CODE'];
                                onItemSelected(selectedService);
                                price(finalPrice);
                                productCode(examCode);
                                controller.text = selectedService;
                                Navigator.pop(context);
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}