import 'package:boks/features/home/bills/waec_and_jamb/waec/components/waec_service_bottom_sheet.dart';
import 'package:boks/features/home/bills/waec_and_jamb/waec/service/waec_service.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../utility/constants/app_strings.dart';
import '../../../../../../utility/shared_components/custom_back_button.dart';
import '../../../airtime/components/airtime_service_provider_bottom_sheet.dart';
import '../../../airtime/provider/airtime_provider.dart';

class WaecScreen extends StatefulWidget {
  const WaecScreen({super.key});

  @override
  State<WaecScreen> createState() => _WaecScreenState();
}

class _WaecScreenState extends State<WaecScreen> {
  final _phoneNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _networkController = TextEditingController();
  final WaecService _waecService = WaecService();
  String? _selectedItem;
  final TextEditingController _controller = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureWaecServices;

  @override
  void initState() {
    _futureWaecServices = _waecService.getAllWaecService(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDropdown() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return WaecServiceBottomSheet(
          data: _futureWaecServices,
          onItemSelected: (selectedService) {
            setState(() {
              _controller.text = selectedService;
            });
          },
          price: (selectedServicePrice) {
            setState(() {
              _priceController.text = selectedServicePrice;
            });
          },
          productCode: (selectedServiceCode) {
            setState(() {
              _controller.text = selectedServiceCode;
            });
          },
          controller: _controller,
        );
      },
    );
  }

  Future<void> _serviceProviderBottomSheet(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return AirtimeServiceProviderBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems =
        Provider.of<AirtimeProvider>(context).selectedProvider;
    _networkController.text = selectedItems!.name;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(context: context),
        centerTitle: true,
        title: const Text(
          "WAEC",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset("images/splash_screen_logo.png"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Select WAEC Service",
              prefixIcon: null,
              isObscure: false,
              controller: _controller,
              onTap: _showDropdown,
              readOnly: true,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppStrings.nairaSign}${_formatPrice(double.tryParse(_priceController.text) ?? 0)}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        Icon(IconlyBold.lock, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: "Phone Number",
              prefixIcon: Icon(IconlyBold.call, color: Colors.grey),
              isObscure: false,
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Select Network",
              prefixIcon: null,
              isObscure: false,
              controller: _networkController,
              onTap: () => _serviceProviderBottomSheet(context),
              readOnly: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomButton(title: "Pay", onClick: () {}, isLoading: false),
      ),
    );
  }

  String _formatPrice(double price) {
    try {
      return _formatNumber(price);
    } catch (e) {
      print('Error formatting price: $e');
      return '0';
    }
  }

  String _formatNumber(double number) {
    NumberFormat formatter = NumberFormat("#,###.##");
    return formatter.format(number);
  }
}
